def _rates_payload(query_params):
    import time, json
    from bisect import bisect_left

    # first value helper (dict/list/Starlette QueryParams)
    def _first(q, key, default=None):
        try:
            v = q.get(key, default)
        except Exception:
            v = default
        if isinstance(v, (list, tuple)):
            return v[0] if v else default
        return v

    # windows: CSV -> ints in [1..3600], unique, max 8 (Fallback 5,60,300)
    raw = _first(query_params, "w", "5,60,300")
    tokens = [t.strip() for t in str(raw).split(",")] if raw is not None else ["5","60","300"]
    windows, seen = [], set()
    for tok in tokens:
        if not tok:
            continue
        try:
            w = int(tok)
        except Exception:
            continue
        if 1 <= w <= 3600 and w not in seen:
            seen.add(w)
            windows.append(w)
    if not windows:
        windows = [5, 60, 300]
    windows = windows[:8]

    # decimals clamp 0..6
    try:
        dec = int(_first(query_params, "dec", 3))
    except Exception:
        dec = 3
    dec = max(0, min(dec, 6))

    # optional path filter
    pf = _first(query_params, "path", None)
    path_filter = str(pf) if pf else None

    # collect timestamps (filtered)
    ts = []
    try:
        with open(AUDIT_PATH, "rb") as f:
            for line in f:
                try:
                    rec = json.loads(line)
                except Exception:
                    continue
                if path_filter and rec.get("path") != path_filter:
                    continue
                t = rec.get("ts")
                if isinstance(t, int):
                    ts.append(t)
    except FileNotFoundError:
        pass

    out = {}
    n = len(ts)
    if n:
        ts.sort()
        now_ms = int(time.time() * 1000)
        for w in windows:
            cutoff = now_ms - w * 1000
            idx = bisect_left(ts, cutoff)
            c = n - idx
            out[f"count_{w}s"] = c
            out[f"rps_{w}s"] = round(c / float(w), dec)

        out["overall_count"] = n
        if n >= 2:
            dur = max(1e-9, (ts[-1] - ts[0]) / 1000.0)
            out["overall_rps"] = round(n / dur, 3)
        else:
            out["overall_rps"] = 0.0
    else:
        for w in windows:
            out[f"count_{w}s"] = 0
            out[f"rps_{w}s"] = 0.0
        out["overall_count"] = 0
        out["overall_rps"] = 0.0

    return out
