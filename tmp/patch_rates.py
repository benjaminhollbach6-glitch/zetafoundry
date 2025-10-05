import sys, re, pathlib, datetime

p = pathlib.Path(sys.argv[1]).expanduser()
src = p.read_text(encoding="utf-8")

# Backup
bk = p.with_suffix(p.suffix + ".bak." + datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%SZ"))
bk.write_text(src, encoding="utf-8")

# Vorhandenen _audit_rates Handler (falls einer da ist) entfernen
src = re.sub(
    r"(?ms)^async\s+def\s+_audit_rates\s*\([^)]*\):.*?(?=^\S|^\s*async\s+def|\Z)",
    "",
    src,
)

# Robuster JSON-Wrapper-Handler anhängen
safe_handler = '''
from starlette.responses import JSONResponse

async def _audit_rates(request):
    import traceback
    try:
        payload = _rates_payload(request.query_params)
        return JSONResponse(payload, headers={"Cache-Control": "no-store"})
    except Exception:
        return JSONResponse(
            {"ok": False, "error": "handler crashed", "trace": traceback.format_exc()},
            status_code=500
        )
'''
if not src.endswith("\n"):
    src += "\n"
src += safe_handler.strip() + "\n"

p.write_text(src, encoding="utf-8")
print("[OK] wrote safe _audit_rates to", p)
