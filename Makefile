PYBIN ?= .venv/bin/python
export PYTHONPATH = app

.PHONY: venv install test
venv:
	python3 -m venv .venv
install:
	$(PYBIN) -m pip install -U pip
	$(PYBIN) -m pip install -r requirements.txt
test:
	$(PYBIN) -m pytest -q
