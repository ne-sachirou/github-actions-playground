SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

lint: lint-gha lint-renovate ## Lint
	yamllint .

lint-gha:
	npx prettier -c .github/workflows/
	yamllint .github/workflows/
	actionlint
	ghalint run
	zizmor .

lint-renovate:
	npx --package renovate@43.3.4 -- renovate-config-validator --strict
