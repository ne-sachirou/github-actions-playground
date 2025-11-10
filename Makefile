SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

lint: lint-gha lint-renovate ## Lint
	yamllint .

lint-gha:
	yamllint .github/workflows/
	actionlint
	ghalint run
	zizmor .

lint-renovate:
	npx --package renovate@42.2.0 -- renovate-config-validator --strict
