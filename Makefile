SHELL := /usr/bin/env bash -Eeu -o pipefail

.PHONY: build
build:
	docker-compose build $$([[ "$${CI:-}" == "true" ]] && echo '--progress plain')

.PHONY: release
release: build
	docker-compose push
