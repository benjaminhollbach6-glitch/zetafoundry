import json, os, hashlib, hmac

def _root():
    here = os.path.abspath(os.path.dirname(__file__))
    return os.path.abspath(os.path.join(here, "..", ".."))

def _paths():
    r = _root()
    return (os.path.join(r, "config", "audit.secret"),
            os.path.join(r, "data", "audit.jsonl"))

def _load_secret(p):
    try:
        with open(p, "rb") as f:
            b = f.read().strip()
            return b or b"\x00"
    except Exception:
        return b"\x00"

def _sha256(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()

def patched_verify_all():
    sp, ap = _paths()
    sec = _load_secret(sp)
    issues = []
    checked = 0
    legacy_ok = 0
    prev = "0"*64
    try:
        with open(ap, "rb") as f:
            for idx, line in enumerate(f, start=1):
                try:
                    d = json.loads(line.decode("utf-8","ignore"))
                except Exception:
                    issues.append({"line": idx, "error": "JSON_DECODE"})
                    continue

                # Neues Schema: prev + sha256(canon_without_hmac)
                body = {k:v for k,v in d.items() if k != "hmac"}
                canon = json.dumps(body, sort_keys=True, separators=(",", ":")).encode("utf-8")
                exp_new = hmac.new(sec, (prev + _sha256(canon)).encode("utf-8"), hashlib.sha256).hexdigest()

                # Legacy-Schema: prev + resp_sha256
                rs = str(d.get("resp_sha256", ""))
                exp_legacy = hmac.new(sec, (prev + rs).encode("utf-8"), hashlib.sha256).hexdigest()

                got = d.get("hmac")
                if got == exp_new:
                    prev = got
                elif got == exp_legacy:
                    prev = got
                    legacy_ok += 1
                else:
                    issues.append({"line": idx, "error": "HMAC_MISMATCH"})
                checked += 1
    except FileNotFoundError:
        pass
    return {"ok": len(issues)==0, "issues": issues, "checked": checked, "legacy_ok": legacy_ok}

# --- write patch into module file in-place
mod_path = os.path.join(_root(), "app", "websvc", "zfx_audit_inline.py")
src = open(mod_path, "r", encoding="utf-8").read()
import re
new_func = '''
def _verify_all() -> dict:
    from ._verify_patch import patched_verify_all
    return patched_verify_all()
'''.strip()
# Replace existing def _verify_all(...) block (naiv aber robust)
src = re.sub(r"def _verify_all\\(.*?\\)\\s*:(?:.|\\n)*?\\n(?=def|class|$)", new_func + "\\n\\n", src, count=1, flags=re.S)
open(mod_path, "w", encoding="utf-8").write(src)
print("[patch] zfx_audit_inline._verify_all installed")
