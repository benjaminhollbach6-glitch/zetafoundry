from __future__ import annotations
import os, json, time, uuid, hashlib, hmac

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SECRET_PATH = os.path.join(ROOT, "config", "audit.secret")
AUDIT_PATH  = os.path.join(ROOT, "data", "audit.jsonl")

def _secret() -> bytes:
    try:
        with open(SECRET_PATH, "rb") as f:
            b = f.read().strip()
            return b or b"\x00"
    except FileNotFoundError:
        os.makedirs(os.path.dirname(SECRET_PATH), exist_ok=True)
        s = os.urandom(32)
        with open(SECRET_PATH, "wb") as f: f.write(s)
        return s

def _canon_no_hmac(rec: dict) -> bytes:
    return json.dumps({k:v for k,v in rec.items() if k!="hmac"},
                      sort_keys=True, separators=(",",":")).encode("utf-8")

def _last_prev() -> str:
    try:
        with open(AUDIT_PATH, "rb") as f:
            last = None
            for line in f:
                if line.strip(): last = line
            if not last: return "0"*64
            d = json.loads(last.decode("utf-8","ignore"))
            return d.get("hmac","0"*64)
    except FileNotFoundError:
        return "0"*64
    except Exception:
        return "0"*64

def append_event(path: str, status: int, req: dict, resp_sha256: str) -> dict:
    os.makedirs(os.path.dirname(AUDIT_PATH), exist_ok=True)
    prev = _last_prev()
    rec = {
        "id": str(uuid.uuid4()),
        "ts": int(time.time()*1000),
        "path": path,
        "status": int(status),
        "req": req or {},
        "resp_sha256": str(resp_sha256),
        "prev": prev,
    }
    sec   = _secret()
    canon = _canon_no_hmac(rec)
    rec["hmac"] = hmac.new(sec, (prev + hashlib.sha256(canon).hexdigest()).encode("utf-8"),
                           hashlib.sha256).hexdigest()
    with open(AUDIT_PATH, "ab") as f:
        f.write(json.dumps(rec, separators=(",",":"), sort_keys=False).encode("utf-8")+b"\n")
        f.flush()
        os.fsync(f.fileno())
    return rec

def audit_tail(n: int = 10):
    try:
        with open(AUDIT_PATH, "rb") as f:
            lines = f.readlines()[-max(1,int(n)):]
        out=[]
        for line in lines:
            if line.strip():
                out.append(json.loads(line.decode("utf-8","ignore")))
        return out
    except FileNotFoundError:
        return []

def audit_verify():
    issues=[]; checked=0; prev="0"*64; sec=_secret()
    try:
        with open(AUDIT_PATH, "rb") as f:
            for idx, line in enumerate(f, start=1):
                if not line.strip(): continue
                try:
                    d = json.loads(line.decode("utf-8","ignore"))
                except Exception:
                    issues.append({"line": idx, "error":"JSON_DECODE"}); continue
                body  = {k:v for k,v in d.items() if k!="hmac"}
                canon = json.dumps(body, sort_keys=True, separators=(",",":")).encode("utf-8")
                exp   = hmac.new(sec, (prev + hashlib.sha256(canon).hexdigest()).encode("utf-8"),
                                 hashlib.sha256).hexdigest()
                got = d.get("hmac")
                if got != exp:
                    issues.append({"line": idx, "error":"HMAC_MISMATCH"})
                else:
                    prev = got
                checked += 1
    except FileNotFoundError:
        pass
    return {"ok": len(issues)==0, "issues": issues, "checked": checked}
