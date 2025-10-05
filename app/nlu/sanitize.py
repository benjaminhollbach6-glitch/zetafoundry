from __future__ import annotations
import unicodedata as _ud

def _norm(s: str) -> str:
    s = _ud.normalize("NFKC", s).casefold()
    out, last_space = [], True
    for ch in s:
        if ch.isalnum() or ch == "_":
            out.append(ch); last_space = False
        else:
            if not last_space:
                out.append(" "); last_space = True
    return "".join(out).strip()

def tokens(s: str, minlen: int = 1) -> list[str]:
    base = _norm(s)
    seen, uniq = set(), []
    for t in base.split():
        if len(t) >= minlen and t not in seen:
            uniq.append(t); seen.add(t)
    return uniq

def fts_match_string(s: str) -> str:
    toks = tokens(s)
    if not toks:
        return ""
    parts = []
    for t in toks:
        t = t.replace('"', '')
        parts.append(f'"{t}*"' if len(t) >= 3 else f'"{t}"')
    return " OR ".join(parts)

def sanitize_for_search(s: str) -> str:
    return " ".join(tokens(s))
