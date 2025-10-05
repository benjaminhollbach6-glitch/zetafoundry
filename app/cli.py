import os, sys, json
from kb.index import ensure_db, import_paths, search, backup
from gen.quantaforge import compose
from tools.validate import validate
from mem.chronicle import remember, recall
def main():
    if len(sys.argv)<2:
        print("Usage: zfx <selftest|import|search|gen|backup|remember|recall|run> [...]"); sys.exit(1)
    cmd=sys.argv[1]
    if cmd=="selftest":
        ensure_db()
        base=os.getenv("ZFX_DATA", os.path.expanduser("~/neon/nx/projects/zetafoundry/data"))
        os.makedirs(base, exist_ok=True)
        s=os.path.join(base,"sample.txt")
        if not os.path.exists(s):
            with open(s,"w",encoding="utf-8") as f: f.write("ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.")
        import_paths([s]); print("SELFTEST: OK")
    elif cmd=="import":
        n=import_paths(sys.argv[2:] or [os.getenv("ZFX_DATA", os.path.expanduser("~/neon/nx/projects/zetafoundry/data"))]); print("Imported:", n)
    elif cmd=="search":
        q=" ".join(sys.argv[2:]) or "Scriptbot"; print(json.dumps(search(q,limit=7), ensure_ascii=False, indent=2))
    elif cmd=="gen":
        prompt=" ".join(sys.argv[2:]) or "installer+service+health+metrics (bash)"
        outs=compose(prompt, lang="bash", variants=2)
        res=[]
        for o in outs:
            v=validate(o["lang"],o["text"])
            res.append({"name":o["name"],"ok":(not v["policy"] and v["syntax_ok"]), "validation":v, "text":o["text"]})
        print(json.dumps(res, ensure_ascii=False, indent=2))
    elif cmd=="backup":
        dst=sys.argv[2] if len(sys.argv)>2 else os.path.join(os.path.expanduser("~/"), "zfx_backup.sql"); print("Backup:", backup(dst))
    elif cmd=="remember":
        session=sys.argv[2] if len(sys.argv)>2 else "default"; text=" ".join(sys.argv[3:]) if len(sys.argv)>3 else "note"
        remember(session,"user",text); print("OK")
    elif cmd=="recall":
        session=sys.argv[2] if len(sys.argv)>2 else "default"; import pprint; pprint.pp(recall(session,limit=12))
    elif cmd=="run":
        import uvicorn; from websvc.api import app
        host=os.getenv("ZFX_HOST","127.0.0.1"); port=int(os.getenv("ZFX_PORT","8785")); uvicorn.run(app, host=host, port=port)
    else:
        print("Unknown cmd"); sys.exit(2)
if __name__=="__main__": main()
