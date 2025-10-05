from __future__ import annotations
import os, time
from collections import defaultdict, deque
from typing import Deque, Dict, Tuple

# Konfiguration via Env
RATE_WINDOW = float(os.environ.get("ZFX_RATE_WINDOW", "3.0"))    # Sekunden
RATE_MAX    = int(os.environ.get("ZFX_RATE_MAX", "12"))          # max Requests innerhalb Fenster
MAX_BODY    = int(os.environ.get("ZFX_MAX_BODY", str(256*1024))) # Bytes (Default 256KB)

# Speicher für Sliding-Window (pro (ip,path))
_Buckets: Dict[Tuple[str,str], Deque[float]] = defaultdict(deque)

def _ip_from_scope(scope) -> str:
    client = scope.get("client") or ("", 0)
    host = client[0] if isinstance(client, (tuple, list)) and client else ""
    # Optional: X-Forwarded-For NICHT vertrauen (lokal)
    return host or "local"

def allow_rate(request) -> bool:
    """True → erlaubt, False → 429"""
    ip  = _ip_from_scope(request.scope)
    path= request.url.path
    now = time.monotonic()
    dq  = _Buckets[(ip, path)]
    cutoff = now - RATE_WINDOW
    while dq and dq[0] < cutoff:
        dq.popleft()
    if len(dq) >= RATE_MAX:
        return False
    dq.append(now)
    return True

def body_too_large(raw: bytes) -> bool:
    return len(raw) > MAX_BODY

def limits_info() -> dict:
    return {"RATE_WINDOW": RATE_WINDOW, "RATE_MAX": RATE_MAX, "MAX_BODY": MAX_BODY}
