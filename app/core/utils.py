from __future__ import annotations
import os, time, uuid, hashlib, json
def now_iso(): return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
def now_ts():  return int(time.time())
def rid(n=12): return uuid.uuid4().hex[:n]
def sha256s(s:str)->str: return hashlib.sha256(s.encode("utf-8")).hexdigest()
def write_text(path:str, content:str, exec_:bool=False):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path,"w",encoding="utf-8",newline="\n") as f: f.write(content)
    if exec_: os.chmod(path,0o755)
    return path
def jdump(x)->str: return json.dumps(x, ensure_ascii=False, indent=2)
