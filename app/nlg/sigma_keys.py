# SigmaEntropyKeys: Zeichenentropie + Token-Diversität + Längenbonus
import math, re
def entropy(s:str)->float:
    if not s: return 0.0
    from collections import Counter
    c=Counter(s); n=len(s)
    return -sum((v/n)*math.log2(v/n) for v in c.values())
def phrases(t:str):
    words=re.findall(r"[a-zA-Z0-9\-]+", t.lower())
    ph=[]; cur=[]
    for w in words:
        if len(w)<=2:
            if cur: ph.append(" ".join(cur)); cur=[]
        else:
            cur.append(w)
    if cur: ph.append(" ".join(cur))
    return ph
def top_keys(text:str, k=8):
    cand=phrases(text); sc=[(p, entropy(p)+0.1*len(p.split())+0.05*len(set(p))) for p in cand]
    sc.sort(key=lambda x:x[1], reverse=True)
    return [p for p,_ in sc[:k]]
