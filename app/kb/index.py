import os, re, sqlite3, glob
CHUNK=1200
def db_path()->str:
    base=os.getenv("ZFX_DATA", os.path.expanduser("~/neon/nx/projects/zetafoundry/data"))
    return os.path.join(base,"zfx.db")
def ensure_db():
    p=db_path(); os.makedirs(os.path.dirname(p), exist_ok=True)
    con=sqlite3.connect(p); cur=con.cursor()
    cur.executescript("""
      pragma journal_mode=wal;
      create table if not exists docs(id integer primary key, title text, content text, ts integer default (strftime('%s','now')));
      create virtual table if not exists docs_fts using fts5(title, content, content='docs', content_rowid='id');
      create trigger if not exists docs_ai after insert on docs begin
        insert into docs_fts(rowid,title,content) values (new.id,new.title,new.content);
      end;
      create trigger if not exists docs_au after update on docs begin
        insert into docs_fts(docs_fts,rowid,title,content) values('delete',old.id,old.title,old.content);
        insert into docs_fts(rowid,title,content) values (new.id,new.title,new.content);
      end;
      create trigger if not exists docs_ad after delete on docs begin
        insert into docs_fts(docs_fts,rowid,title,content) values('delete',old.id,old.title,old.content);
      end;
    """); con.commit(); con.close()
def _read(p):
    with open(p,"r",encoding="utf-8",errors="ignore") as f: return f.read().replace("\r\n","\n")
def _chunks(text:str, n:int=CHUNK):
    for i in range(0,len(text),n): yield text[i:i+n]
def import_paths(paths):
    ensure_db(); p=db_path()
    con=sqlite3.connect(p); cur=con.cursor(); n=0
    for path in paths:
      if os.path.isdir(path):
        for pat in ("*.txt","*.md","*.html","*.csv","*.json"):
          for f in glob.glob(os.path.join(path, pat)):
            txt=_read(f)
            for j,chunk in enumerate(_chunks(txt)):
              cur.execute("insert into docs(title,content) values(?,?)",(os.path.basename(f)+f"::{j}",chunk)); n+=1
      elif os.path.isfile(path):
        txt=_read(path)
        for j,chunk in enumerate(_chunks(txt)):
          cur.execute("insert into docs(title,content) values(?,?)",(os.path.basename(path)+f"::{j}",chunk)); n+=1
    con.commit(); con.close(); return n
_ALNUM = re.compile(r"[A-Za-z0-9]+")
def _sanitize_for_fts(q:str)->str:
    toks=_ALNUM.findall(q or "")
    if not toks: return ""
    seen=set(); uniq=[]
    for t in toks:
        if t not in seen:
            seen.add(t); uniq.append(t)
        if len(uniq)>=16: break
    return " OR ".join(uniq)
def search(q, limit=7):
    ensure_db(); p=db_path()
    con=sqlite3.connect(p); con.row_factory=sqlite3.Row; cur=con.cursor()
    fts=_sanitize_for_fts(q)
    try:
        if not fts: return []
        cur.execute("""
          with ranked as (
            select d.id,d.title,d.content,d.ts, bm25(docs_fts) as s
            from docs_fts join docs d on d.id=docs_fts.rowid
            where docs_fts match ?
          )
          select id,title,content, s + ((strftime('%s','now')-ts)/31557600.0)*0.05 as score
          from ranked order by score asc limit ?;
        """,(fts, limit))
        out=[{"id":r["id"],"title":r["title"],"content":r["content"],"score":r["score"]} for r in cur.fetchall()]
        con.close(); return out
    except sqlite3.OperationalError:
        try:
            cur.execute("select id,title,content, 0.0 as score from docs where content like ? order by id desc limit ?",
                        (f"%{(q or '')[:80]}%", limit))
            out=[{"id":r["id"],"title":r["title"],"content":r["content"],"score":0.0} for r in cur.fetchall()]
            con.close(); return out
        except Exception:
            con.close(); return []
def backup(dst:str)->str:
    ensure_db(); p=db_path(); con=sqlite3.connect(p)
    with open(dst,"wb") as f:
        for line in con.iterdump(): f.write((line+"\n").encode("utf-8"))
    con.close(); return dst
