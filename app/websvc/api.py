from nlu.sanitize import sanitize_for_search
from starlette.applications import Starlette
from starlette.responses import JSONResponse, Response
from starlette.routing import Route
from starlette.requests import Request
import time
from importlib import reload

from core.metrics import REQS, LAT, ERRS, metrics_bytes, CONTENT_TYPE_LATEST
from core.logs import jlog
from security.guard import allow_rate, body_too_large, limits_info, MAX_BODY
from kb.index import ensure_db, import_paths
from mem.chronicle import remember, recall
import nlg.brain as brain
from core.schema import (
    AskPayload, GenPayload, ImportPayload, RememberPayload,
    parse_model, model_schema, ValidationErr
)

ensure_db()

def _err(status:int, msg:str, **extra):
    body={"error": msg}
    if extra: body["details"]=extra
    return JSONResponse(body, status_code=status)

async def health(request:Request):
    REQS.labels("/health","200").inc()
    return JSONResponse({"status":"ok","ts":int(time.time())})

async def metrics(request:Request):
    return Response(metrics_bytes(), media_type=CONTENT_TYPE_LATEST)

async def limits_ep(request:Request):
    return JSONResponse(limits_info())

async def ask(request:Request):
    t=time.time()
    try:
        if not allow_rate(request): REQS.labels("/ask","429").inc(); return _err(429,"rate_limited")
        raw=await request.body()
        if body_too_large(raw): REQS.labels("/ask","413").inc(); return _err(413,"payload_too_large", max=MAX_BODY)
        try:
            payload = parse_model(AskPayload, raw).norm()
        except ValidationErr as e:
            REQS.labels("/ask","422").inc()
            return _err(422,"invalid_payload", errors=getattr(e, "errors", lambda: str(e))())
        reload(brain)
        out=brain.answer(payload.q, session=payload.session)
        LAT.labels("/ask").observe(time.time()-t); REQS.labels("/ask","200").inc(); jlog("ask", q=payload.q[:120], hits=out.get("hits",[]), session=payload.session)
        return JSONResponse(out)
    except Exception as e:
        ERRS.labels("ask").inc(); REQS.labels("/ask","500").inc()
        return _err(500, str(e))

async def gen(request:Request):
    t=time.time()
    try:
        if not allow_rate(request): REQS.labels("/gen","429").inc(); return _err(429,"rate_limited")
        raw=await request.body()
        if body_too_large(raw): REQS.labels("/gen","413").inc(); return _err(413,"payload_too_large", max=MAX_BODY)
        try:
            payload = parse_model(GenPayload, raw)
        except ValidationErr as e:
            REQS.labels("/gen","422").inc()
            return _err(422,"invalid_payload", errors=getattr(e, "errors", lambda: str(e))())
        outs = __import__("gen.quantaforge", fromlist=["compose"]).compose(payload.prompt, lang="bash", variants=payload.variants)
        validate = __import__("tools.validate", fromlist=["validate"]).validate
        res=[]
        for o in outs:
            v=validate(o["lang"], o["text"])
            res.append({"name":o["name"],"lang":o["lang"],"ok":(not v["policy"] and v["syntax_ok"]), "validation":v, "text":o["text"]})
        LAT.labels("/gen").observe(time.time()-t); REQS.labels("/gen","200").inc(); jlog("gen", prompt=payload.prompt[:120], count=len(res))
        return JSONResponse({"results":res})
    except Exception as e:
        ERRS.labels("gen").inc(); REQS.labels("/gen","500").inc()
        return _err(500, str(e))

async def do_import(request:Request):
    try:
        if not allow_rate(request): REQS.labels("/import","429").inc(); return _err(429,"rate_limited")
        raw=await request.body()
        if body_too_large(raw): REQS.labels("/import","413").inc(); return _err(413,"payload_too_large", max=MAX_BODY)
        try:
            payload = parse_model(ImportPayload, raw)
        except ValidationErr as e:
            REQS.labels("/import","422").inc()
            return _err(422,"invalid_payload", errors=getattr(e, "errors", lambda: str(e))())
        n=import_paths(payload.paths)
        REQS.labels("/import","200").inc(); return JSONResponse({"imported":n})
    except Exception as e:
        REQS.labels("/import","500").inc(); return _err(500, str(e))

async def remember_api(request:Request):
    try:
        raw=await request.body()
        if body_too_large(raw): return _err(413,"payload_too_large", max=MAX_BODY)
        try:
            payload = parse_model(RememberPayload, raw).norm()
        except ValidationErr as e:
            return _err(422,"invalid_payload", errors=getattr(e, "errors", lambda: str(e))())
        remember(payload.session,"user",payload.text); return JSONResponse({"status":"ok"})
    except Exception as e:
        return _err(500, str(e))

async def recall_api(request:Request):
    try:
        session=(request.query_params.get("session") or "default").strip() or "default"
        out=recall(session, limit=12)
        return JSONResponse({"session":session,"memory":out})
    except Exception as e:
        return _err(500, str(e))

async def schema_api(request:Request):
    sch = {
        "AskPayload": model_schema(AskPayload),
        "GenPayload": model_schema(GenPayload),
        "ImportPayload": model_schema(ImportPayload),
        "RememberPayload": model_schema(RememberPayload),
    }
    return JSONResponse(sch)

routes=[
  Route("/health", health),
  Route("/metrics", metrics),
  Route("/schema", schema_api, methods=["GET"]),
  Route("/limits", limits_ep, methods=["GET"]),
  Route("/ask", ask, methods=["POST"]),
  Route("/gen", gen, methods=["POST"]),
  Route("/import", do_import, methods=["POST"]),
  Route("/remember", remember_api, methods=["POST"]),
  Route("/recall", recall_api, methods=["GET"]),
]
app=Starlette(routes=routes)

# --- P3: Audit-Hooks (Middleware + Routen) --------------------------------------
try:
    from core.audit import wrap_audit, install_audit_routes
    try:
        install_audit_routes(app)
    except Exception as _e:
        pass
    try:
        app.middleware("http")(wrap_audit())
    except Exception as _e:
        pass
except Exception as _outer:
    pass

# --- ZFX Audit routes (idempotent tail/verify) ---------------------------------
try:
    from fastapi import APIRouter
    from core.audit import audit_tail, audit_verify  # uses HMAC chain in data/audit.jsonl
    _zfx_audit_router = APIRouter()

    @_zfx_audit_router.get("/audit")
    def _zfx_audit_tail(limit: int = 10):
        entries = audit_tail(max(1, min(limit, 1000)))
        return {"entries": entries, "count": len(entries)}

    @_zfx_audit_router.get("/audit/verify")
    def _zfx_audit_verify():
        return audit_verify()

    try:
        app.include_router(_zfx_audit_router)  # type: ignore[name-defined]
    except Exception:
        pass
except Exception:
    # routes optional; never block startup
    pass

# --- ZFX: wire audit routes (managed) ------------------------------------------
try:
    from websvc.audit_routes import wire_audit_routes  # type: ignore
    wire_audit_routes(app)
except Exception:
    # Start nie blockieren
    pass


# === ZFX AUDIT INLINE (json-safe) ==============================================
try:
    import sys
    from websvc.zfx_audit_inline import install as _zfx_audit_install
    _mode = _zfx_audit_install(app)
    print(f"[ZFX] AUDIT inline installed mode={_mode}", file=sys.stderr)
except Exception as _e:
    import sys
    print(f"[ZFX] AUDIT inline disabled: {_e}", file=sys.stderr)
# === END ZFX AUDIT INLINE ======================================================

# === ZFX AUDIT TAP (ASGI) ======================================================
try:
    from websvc._zfx_audit_tap import install as _zfx_audit_tap_install
    _wrapped = _zfx_audit_tap_install(app)
    if _wrapped is not None and _wrapped is not True:
        # Das install() liefert das neue App-Objekt zurück → ersetzen
        app = _wrapped  # type: ignore[assignment]
        # Marker bleibt auf app._zfx_audit_wrapped
except Exception as _e:
    import sys
    print(f"[ZFX] AUDIT TAP disabled: {_e}", file=sys.stderr)
# === END ZFX AUDIT TAP ==========================================================
