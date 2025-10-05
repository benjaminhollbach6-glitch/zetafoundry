from __future__ import annotations
from typing import List
try:
    import pydantic
    from pydantic import BaseModel, Field, ValidationError
except Exception as e:
    raise RuntimeError(f"Pydantic nicht verfügbar: {e}")

def parse_model(model, raw: bytes):
    data = raw.decode("utf-8", errors="ignore")
    if hasattr(model, "model_validate_json"):
        return model.model_validate_json(data)   # v2
    return model.parse_raw(data)                 # v1

def model_schema(model) -> dict:
    if hasattr(model, "model_json_schema"):
        return model.model_json_schema()         # v2
    return model.schema()                        # v1

def _norm_s(s: str, default: str = "") -> str:
    s = (s or "").strip()
    return s if s else default

class AskPayload(BaseModel):
    session: str = Field(default="default", max_length=128)
    q: str = Field(min_length=1, max_length=2000)
    def norm(self) -> "AskPayload":
        return AskPayload(session=_norm_s(self.session, "default"), q=_norm_s(self.q))

class GenPayload(BaseModel):
    prompt: str = Field(min_length=1, max_length=4000)
    variants: int = Field(default=1, ge=1, le=5)

class ImportPayload(BaseModel):
    paths: List[str]

class RememberPayload(BaseModel):
    session: str = Field(default="default", max_length=128)
    text: str = Field(min_length=1, max_length=4000)
    def norm(self) -> "RememberPayload":
        return RememberPayload(session=_norm_s(self.session, "default"), text=_norm_s(self.text))

ValidationErr = ValidationError
