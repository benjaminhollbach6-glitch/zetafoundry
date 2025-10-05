from __future__ import annotations
import re, random
from gen.templates import build_bash
from intent.parse import parse_request
from gen.dsl import parse_dsl
def slug(base="gen"):
    s=re.sub(r"[^a-z0-9]+","-", base.lower()).strip("-") or "gen"
    return s[:24]+"-"+str(random.randint(100,999))
def compose(prompt:str, lang="auto", variants=1):
    req=parse_request(prompt)
    if lang!="auto": req["lang"]=lang
    if variants: req["variants"]=variants
    feats=set(parse_dsl(prompt))
    wants=req["wants"].copy()
    for k in ["installer","service","health","metrics","sqlite"]:
        if k in feats: wants[k]=True
    outs=[]
    for _ in range(max(1,int(req["variants"]))):
        name=slug()
        txt = build_bash(name, wants) if req["lang"]=="bash" else "# python template not enabled"
        outs.append({"name":name,"lang":req["lang"],"text":txt})
    return outs
