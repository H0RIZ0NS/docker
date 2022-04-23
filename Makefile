export SHELL := /usr/bin/env bash -Eeu -o pipefail

test.build test.run: export COMPOSE_FILE=docker-compose.test.yml
release: export COMPOSE_FILE=docker-compose.release.yml

.PHONY: build
build:
	docker compose build

.PHONY: test.build
test.build:
	COMPOSE_PROFILES=base $(MAKE) build
	COMPOSE_PROFILES=test $(MAKE) build

.PHONY: test.run
test.run:
	docker compose run --rm php7-test
	docker compose run --rm php7-fpm-test
	docker compose run --rm node16-test

.PHONY: release
release: build
	docker compose push
