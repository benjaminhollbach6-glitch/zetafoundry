from intent.parse import parse_request
from kb.index import db_path
from nlg.vortexrank import summarize
from nlg.sigma_keys import top_keys
from mem.chronicle import recall
import sqlite3, re
_ALNUM = re.compile(r"[A-Za-z0-9]+")
def _sanitize_tokens(q:str, cap:int=16):
    toks=_ALNUM.findall(q or ""); seen=set(); out=[]
    for t in toks:
        t=t.lower()
        if t not in seen:
            seen.add(t); out.append(t)
        if len(out)>=cap: break
    return out
def _fts_or_like(q:str, limit:int=7):
    con=sqlite3.connect(db_path()); con.row_factory=sqlite3.Row; cur=con.cursor()
    try:
        toks=_sanitize_tokens(q)
        if toks:
            expr=" OR ".join(f'"{t}"' for t in toks)
            try:
                cur.execute("""
                  with ranked as (
                    select d.id,d.title,d.content,d.ts, bm25(docs_fts) as s
                    from docs_fts join docs d on d.id=docs_fts.rowid
                    where docs_fts match ?
                  )
                  select id,title,content, s + ((strftime('%s','now')-ts)/31557600.0)*0.05 as score
                  from ranked order by score asc limit ?;
                """,(expr, limit))
                return [{"id":r["id"],"title":r["title"],"content":r["content"],"score":r["score"]} for r in cur.fetchall()]
            except Exception:
                pass
        cur.execute("select id,title,content, 0.0 as score from docs where content like ? order by id desc limit ?",
                    (f"%{(q or '')[:80]}%", limit))
        return [{"id":r["id"],"title":r["title"],"content":r["content"],"score":0.0} for r in cur.fetchall()]
    except Exception:
        return []
    finally:
        con.close()
def _safe_parse(q:str)->dict:
    try: return parse_request(q)
    except Exception as e: return {"lang":"bash","wants":{},"parts":[q],"variants":1,"_err":str(e)}
def answer(q:str, session:str)->dict:
    req=_safe_parse(q)
    hist=recall(session, limit=10)
    hist_text=" ".join(h["text"] for h in hist if h["role"]=="user")
    hits=_fts_or_like(q, limit=7)
    corpus=" ".join(h["content"] for h in hits) if hits else ""
    text=" ".join(x for x in [hist_text, corpus, q] if x)
    synopsis=summarize(text, max_sent=3, k=2)
    keys=top_keys(text, k=8)
    body=f"{synopsis}\n\nSchlüsselbegriffe: {', '.join(keys) if keys else '-'}"
    return {"intent":req,"answer":body,"hits":[{"title":h["title"],"score":round(h.get('score',0.0),2)} for h in hits], "memory_used":len(hist)}
