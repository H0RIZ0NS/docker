export SHELL := /usr/bin/env bash -Eeu -o pipefail
export DOCKER_BUILDKIT := 1

.PHONY: build
build:
	docker-compose build $$([[ "$${CI:-}" == 'true' ]] && echo '--progress plain')

.PHONY: release
release: build
	docker-compose push
