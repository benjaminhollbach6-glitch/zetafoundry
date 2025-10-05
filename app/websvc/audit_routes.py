from typing import Any, Dict

def wire_audit_routes(app) -> None:
    # vorhandene Pfade resilient ermitteln
    try:
        existing = {getattr(r, "path", "") for r in getattr(app, "routes", [])}
    except Exception:
        existing = set()

    if "/audit" not in existing:
        @app.get("/audit")
        async def _zfx_audit_tail(limit: int = 10) -> Dict[str, Any]:
            try:
                from core.audit import audit_tail
                l = max(1, min(int(limit), 1000))
                entries = audit_tail(l)
                return {"entries": entries, "count": len(entries)}
            except Exception as e:
                return {"entries": [], "count": 0, "error": str(e)}

    if "/audit/verify" not in existing:
        @app.get("/audit/verify")
        async def _zfx_audit_verify() -> Dict[str, Any]:
            try:
                from core.audit import audit_verify
                return audit_verify()
            except Exception as e:
                return {"ok": False, "issues": [str(e)], "checked": 0}
