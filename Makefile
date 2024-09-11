export SHELL := /usr/bin/env bash -Eeu -o pipefail

.PHONY: test
test:
	cp .env.test .env
	docker compose build
	docker compose run --rm php7.test
	docker compose run --rm php8.test
	docker compose run --rm node20.test

.PHONY: release
release:
	cp .env.release .env
	docker compose build
	docker compose push
