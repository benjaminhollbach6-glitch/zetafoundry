from __future__ import annotations
import hashlib
from urllib.parse import parse_qs

class AuditTap:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope.get("type") != "http":
            return await self.app(scope, receive, send)

        method = scope.get("method","GET")
        path   = scope.get("path","")
        # ZFX: skip self-logging
        if path.startswith(("/audit", "/metrics")):
            return await self.app(scope, receive, send)
        query  = (scope.get("query_string") or b"").decode("latin-1", "ignore")
        req = {"method": method}
        if query:
            req["query"] = {k:(v if len(v)>1 else v[0])
                            for k,v in parse_qs(query, keep_blank_values=True).items()}

        status_code = 500
        hasher = hashlib.sha256()

        async def send_wrapper(message):
            nonlocal status_code
            if message["type"] == "http.response.start":
                status_code = int(message.get("status", message.get("status_code", 200)))
                await send(message)
            elif message["type"] == "http.response.body":
                body = message.get("body") or b""
                hasher.update(body)    # nur mitlesen
                await send(message)    # unverändert weiterreichen
            else:
                await send(message)

        try:
            await self.app(scope, receive, send_wrapper)
        finally:
            try:
                from core.audit import append_event
                append_event(path, status_code, req, hasher.hexdigest())
            except Exception:
                # Audit darf nie den Request brechen
                pass

def install(app):
    if getattr(app, "_zfx_audit_wrapped", False):
        return True
    wrapped = AuditTap(app)
    setattr(wrapped, "_zfx_audit_wrapped", True)
    return wrapped
