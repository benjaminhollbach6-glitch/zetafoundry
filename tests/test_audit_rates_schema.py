import json, pathlib, importlib
from functools import lru_cache
from starlette.testclient import TestClient
import fastjsonschema

@lru_cache(maxsize=1)
def _validator():
    schema = json.loads(pathlib.Path("schema/audit_rates.schema.json").read_text())
    return fastjsonschema.compile(schema)

def _client():
    api = importlib.import_module("websvc.api")
    app = getattr(api.app, "app", api.app)
    return TestClient(app)

def test_schema_valid():
    j = _client().get("/audit/rates", params={"w":"5,60,300","dec":"3"}).json()
    _validator()(j)
