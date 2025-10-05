from __future__ import annotations
import re
_SEP = re.compile(r"\s*,\s*")
def _parts(text: str) -> list[str]:
    t=(text or "").strip()
    if not t: return []
    ps=[p.strip() for p in _SEP.split(t) if p and p.strip()]
    return ps if ps else [t]
def parse_request(text: str) -> dict:
    txt=text or ""; low=txt.lower(); parts=_parts(txt)
    def has(*keys): return any(k in low for k in keys)
    wants={
      "installer": has("installer","setup","ein-klick","patch"),
      "service"  : has("service","daemon","runit","dienst"),
      "health"   : has("health","gesundheit","healthcheck"),
      "metrics"  : has("metrics","prometheus"),
      "sqlite"   : has("sqlite","fts","fts5","bm25","datenbank"),
      "cli"      : has("cli","kommando","command"),
      "variants" : has("varianten","mehrere","multiple"),
      "chain"    : has("kette","chain","workflow","mehrstufig"),
      "creative" : has("kreativ","unique","einzigartig"),
      "complex"  : has("komplex","10/10","tief","advanced"),
    }
    lang="bash" if ("bash" in low or "shell" in low) else ("python" if "python" in low else "bash")
    variants=3 if wants["variants"] else 1
    return {"lang":lang,"wants":wants,"parts":parts,"variants":variants}
