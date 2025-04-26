SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

lint: lint-gha ## Lint
	yamllint .

lint-gha:
	yamllint .github/workflows/
	actionlint
	ghalint run
	zizmor .
