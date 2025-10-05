from prometheus_client import Counter, Histogram, Gauge, CollectorRegistry, generate_latest, CONTENT_TYPE_LATEST
REG = CollectorRegistry()
REQS = Counter("zfx_requests_total","HTTP requests",["path","code"], registry=REG)
LAT  = Histogram("zfx_request_seconds","Latency",["path"], registry=REG, buckets=(0.01,0.02,0.05,0.1,0.2,0.5,1,2,5))
ERRS = Counter("zfx_errors_total","Errors",["type"], registry=REG)
UP   = Gauge("zfx_up","UP", registry=REG); UP.set(1)
def metrics_bytes(): return generate_latest(REG)
