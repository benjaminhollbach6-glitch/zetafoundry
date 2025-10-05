import sys, re, pathlib, datetime

p = pathlib.Path(sys.argv[1]).expanduser()
src = p.read_text(encoding="utf-8")

# Backup
bk = p.with_suffix(p.suffix + ".bak." + datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%SZ"))
bk.write_text(src, encoding="utf-8")

# Existierenden Handler entfernen, falls vorhanden
src = re.sub(
    r"(?ms)^async\s+def\s+_audit_rates\s*\([^)]*\):.*?(?=^\S|^\s*async\s+def|\Z)",
    "",
    src,
)

# Neuen, robusten Handler anhängen (immer application/json)
handler = r'''
async def _audit_rates(request):
    from starlette.responses import JSONResponse
    import logging, traceback

    log = logging.getLogger("zfx.audit")
    try:
        payload = _rates_payload(request.query_params)
        return JSONResponse(payload, headers={"Cache-Control": "no-store"})
    except Exception as e:
        log.exception("rates failed")
        return JSONResponse(
            {"ok": False, "error": str(e), "trace": traceback.format_exc()},
            status_code=500,
            headers={"Cache-Control": "no-store"},
        )
'''
src = src.rstrip() + "\n\n" + handler + "\n"
p.write_text(src, encoding="utf-8")
print("[OK] wrote _audit_rates JSON wrapper to", p)
