export SHELL := /usr/bin/env bash -Eeu -o pipefail

.PHONY: build
build:
	docker compose build

.PHONY: test
test: export COMPOSE_ENV_FILES := .env.test
test: build
	docker compose run --rm php7.test
	docker compose run --rm php8.test
	docker compose run --rm node20.test

.PHONY: release
release: export COMPOSE_ENV_FILES := .env.release
release: build
	docker compose push
