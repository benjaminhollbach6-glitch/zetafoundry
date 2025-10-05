from __future__ import annotations
import sqlite3, os
from pathlib import Path
from typing import List, Dict, Any
from nlu.sanitize import fts_match_string, sanitize_for_search

ROOT = Path(os.environ.get("ZFX_ROOT", str(Path(__file__).resolve().parents[2])))
DB   = ROOT / "data" / "zfx.db"

def _conn() -> sqlite3.Connection:
    c = sqlite3.connect(str(DB))
    c.row_factory = sqlite3.Row
    return c

def search(query: str, limit: int = 8) -> List[Dict[str, Any]]:
    qmatch = fts_match_string(query)
    rows: list[sqlite3.Row] = []
    with _conn() as c:
        if qmatch:
            try:
                rows = c.execute(
                    """
                    SELECT docid, path, bm25(zfx_fts) AS rank,
                           snippet(zfx_fts, '[', ']', ' … ', -1, 64) AS snip
                    FROM zfx_fts
                    WHERE zfx_fts MATCH ?
                    ORDER BY rank LIMIT ?
                    """,
                    (qmatch, int(limit)),
                ).fetchall()
            except sqlite3.OperationalError:
                rows = []
        if not rows:
            like = "%" + "%".join(sanitize_for_search(query).split()) + "%"
            try:
                rows = c.execute(
                    """
                    SELECT id AS docid, path, 0.0 AS rank,
                           substr(text, 1, 160) AS snip
                    FROM zfx_docs
                    WHERE text LIKE ?
                    LIMIT ?
                    """,
                    (like, int(limit)),
                ).fetchall()
            except sqlite3.OperationalError:
                return []
    return [dict(r) for r in rows]
