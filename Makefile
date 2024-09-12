export SHELL := /usr/bin/env bash -Eeu -o pipefail

.PHONY: build
build:
	docker compose build

.PHONY: test
test:
	docker compose run --rm php7.test
	docker compose run --rm php8.test
	docker compose run --rm node20.test
	docker compose run --rm python3.test
	docker compose run --rm ruby3.test

.PHONY: release
release: build
	docker compose push
