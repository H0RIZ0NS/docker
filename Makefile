export SHELL := /usr/bin/env bash -Eeu -o pipefail

test: export COMPOSE_ENV_FILES=.env.test
release: export COMPOSE_ENV_FILES=.env.release

.PHONY: build
build:
	docker compose build

.PHONY: test
test: build
	docker compose run --rm php7.test
	docker compose run --rm php8.test
	docker compose run --rm node20.test

.PHONY: release
release: build
	docker compose push
