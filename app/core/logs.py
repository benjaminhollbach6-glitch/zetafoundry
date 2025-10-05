import os, json, time, uuid
LOG_PATH = os.getenv("ZFX_LOG", os.path.expanduser("~/neon/nx/projects/zetafoundry/logs/zfx.jsonl"))
os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
MAX=12*1024*1024
def now(): return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
def rid(): return uuid.uuid4().hex[:12]
def _rotate():
    try:
        if os.path.exists(LOG_PATH) and os.path.getsize(LOG_PATH) > MAX:
            ts=time.strftime("%Y%m%d%H%M%S", time.gmtime()); os.rename(LOG_PATH, f"{LOG_PATH}.{ts}.bak")
    except Exception: pass
def jlog(kind:str, **kv):
    _rotate()
    with open(LOG_PATH,"a",encoding="utf-8") as f:
        f.write(json.dumps({"ts":now(),"id":rid(),"kind":kind,**kv}, ensure_ascii=False)+"\n")
