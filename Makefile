export SHELL := /usr/bin/env bash -Eeu -o pipefail

.PHONY: build
build:
	docker compose build

.PHONY: test
test:
	docker compose run --rm php7
	docker compose run --rm php8
	docker compose run --rm node20
	docker compose run --rm python3
	docker compose run --rm ruby3

.PHONY: release
release: build
	docker compose push
