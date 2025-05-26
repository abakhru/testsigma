export NODE_OPTIONS=--openssl-legacy-provider

# Root Makefile for managing the Testsigma project

help:
	@echo "Usage: make <target>"
	@echo "Available targets:"
	@echo "  help                   Show this help message (default)"
	@echo "  all                    Build all components (UI, server, automator, agent, agent-launcher)"
	@echo "  ui-install             Install UI dependencies (bun install)"
	@echo "  ui-build               Build the UI (Angular)"
	@echo "  ui-start               Start the UI development server"
	@echo "  ui-test                Run UI tests"
	@echo "  ui-lint                Lint UI code"
	@echo "  server-build           Build the server (Maven)"
	@echo "  server-test            Run server tests (Maven)"
	@echo "  automator-build        Build the automator (Maven)"
	@echo "  automator-test         Run automator tests (Maven)"
	@echo "  agent-build            Build the agent (Maven)"
	@echo "  agent-test             Run agent tests (Maven)"
	@echo "  agent-launcher-build   Build the agent-launcher (Maven)"
	@echo "  agent-launcher-test    Run agent-launcher tests (Maven)"
	@echo "  docker-build           Build the Docker image"
	@echo "  docker-compose-up      Run docker compose up"
	@echo "  docker-compose-down    Run docker compose down"
	@echo "  clean                  Clean all build artifacts"

.DEFAULT_GOAL := help

.PHONY: all ui-install ui-build ui-start ui-test ui-lint \
        server-build server-test \
        automator-build automator-test \
        agent-build agent-test \
        agent-launcher-build agent-launcher-test \
        docker-build docker-compose-up docker-compose-down clean

all: ui-build automator-build server-build agent-build agent-launcher-build

# UI (Angular)
ui-install:
	cd ui && bun install

ui-build: ui-install
	cd ui && bun run build

ui-start:
	cd ui && bun start

ui-test:
	cd ui && bun test || true

ui-lint:
	cd ui && bun run lint

# Server (Maven)
server-build:
	cd server && ./mvnw -U clean install -DskipTests

server-test:
	cd server && ./mvnw test

# Automator (Maven)
automator-build:
	cd automator && ./mvnw -U -Dmaven.compiler.compilerArgs='-Xlint:unchecked -Xlint:deprecation' clean install -DskipTests

automator-test:
	cd automator && ./mvnw test

# Agent (Maven)
agent-build: automator-build
	cd agent && ./mvnw -U clean install -DskipTests

agent-test:
	cd agent && ./mvnw test

# Agent-Launcher (Maven)
agent-launcher-build:
	cd agent-launcher && ./mvnw -U clean install -DskipTests

agent-launcher-test:
	cd agent-launcher && ./mvnw test

# Docker

docker-build:
	docker build -t testsigma .

docker-compose-up:
	docker compose -f ./deploy/docker/docker-compose.yml up

docker-compose-down:
	docker compose -f ./deploy/docker/docker-compose.yml down

# Clean all build artifacts
clean:
	cd ui && rm -rf node_modules dist
	cd server && ./mvnw clean
	cd automator && ./mvnw clean
	cd agent && ./mvnw clean
	cd agent-launcher && ./mvnw clean 
