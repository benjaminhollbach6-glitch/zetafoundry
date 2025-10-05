import os, sqlite3, time
from core.utils import now_ts
def db_path()->str:
    import os
    base=os.getenv("ZFX_DATA", os.path.expanduser("~/neon/nx/projects/zetafoundry/data"))
    return os.path.join(base,"zfx.db")
def ensure_tables():
    p=db_path(); con=sqlite3.connect(p); cur=con.cursor()
    cur.executescript("""
      create table if not exists sessions(id text primary key, created integer);
      create table if not exists memory(
        id integer primary key,
        session_id text,
        role text,
        text text,
        ts integer
      );
      create index if not exists mem_sess_ts on memory(session_id, ts);
    """); con.commit(); con.close()
def remember(session_id:str, role:str, text:str):
    ensure_tables(); p=db_path(); con=sqlite3.connect(p); cur=con.cursor()
    cur.execute("insert or ignore into sessions(id,created) values(?,?)",(session_id, now_ts()))
    cur.execute("insert into memory(session_id,role,text,ts) values(?,?,?,?)",(session_id, role, text, now_ts()))
    con.commit(); con.close()
def recall(session_id:str, limit:int=12):
    ensure_tables(); p=db_path(); con=sqlite3.connect(p); con.row_factory=sqlite3.Row; cur=con.cursor()
    cur.execute("select role,text,ts from memory where session_id=? order by ts desc limit ?", (session_id, limit))
    out=[{"role":r["role"],"text":r["text"],"ts":r["ts"]} for r in cur.fetchall()]
    con.close(); return out
