import importlib, json, pathlib
from starlette.testclient import TestClient
import fastjsonschema

def _client():
    api = importlib.import_module("websvc.api")
    app = getattr(api.app, "app", api.app)
    return TestClient(app)

def _load_schema():
    return json.loads(pathlib.Path("schema/audit_rates.schema.json").read_text())

def test_structured_ok():
    c = _client()
    r = c.get("/audit/rates", params={"w":"5,15,60","dec":"2"})
    assert r.status_code == 200
    j = r.json()
    assert "windows" in j and "overall" in j
    assert {w["w"] for w in j["windows"]} == {5, 15, 60}

def test_fallback_and_clamp():
    c = _client()
    r = c.get("/audit/rates", params={"w":"foo,-1,999999","dec":"9"})
    assert r.status_code == 200
    assert {w["w"] for w in r.json()["windows"]} == {5, 60, 300}

def test_flat_compat():
    c = _client()
    j = c.get("/audit/rates", params={"w":"5,60,300","dec":"3","flat":"1"}).json()
    for k in ("count_5s","rps_5s","count_60s","rps_60s",
              "count_300s","rps_300s","overall_count","overall_rps"):
        assert k in j

def test_dec_clamped_to_6():
    c = _client()
    j = c.get("/audit/rates", params={"w":"5,60,300","dec":"999"}).json()
    # value must be representable at precision ≤ 6
    assert abs(j["overall"]["rps"] - round(j["overall"]["rps"], 6)) < 1e-12

def test_dedupe_and_limit():
    c = _client()
    j = c.get("/audit/rates", params={"w":"1,1,2,2,3,4,5,6,7,8,9,10"}).json()
    assert [w["w"] for w in j["windows"]] == [1,2,3,4,5,6,7,8]

def test_empty_filter_zeroes():
    c = _client()
    j = c.get("/audit/rates", params={"w":"5,5,5","path":"/does-not-exist"}).json()
    assert j["overall"]["count"] == 0
    assert all(w["count"] == 0 and w["rps"] == 0.0 for w in j["windows"])

def test_schema_valid():
    schema = _load_schema()
    validate = fastjsonschema.compile(schema)
    c = _client()
    j = c.get("/audit/rates", params={"w":"5,60,300","dec":"3"}).json()
    validate(j)
def test_empty_filter_zeroes():
    c = _client()
    j = c.get("/audit/rates", params={"w": "5,5,5", "path": "/does-not-exist"}).json()
    assert all(w["count"] == 0 and w["rps"] == 0 for w in j["windows"])
    assert j["overall"]["count"] == 0 and j["overall"]["rps"] == 0
