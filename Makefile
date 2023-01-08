#!make
PROJECT ?= $(shell node -p "require('./package.json').name")
NVM = v0.39.3
NODE ?= $(shell cat $(PWD)/.nvmrc 2> /dev/null || echo v16.15.0)

.PHONY: help install nvm git-hooks gen tags task

default: help

# show this help
help:
	@echo 'usage: make [target] ...'
	@echo ''
	@echo 'targets:'
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## NPM install
	. $(NVM_DIR)/nvm.sh && nvm use $(NODE) && $(CMD)

install: ## Install node version
	. $(NVM_DIR)/nvm.sh && nvm install $(NODE)
	make run CMD="npm install"

## Tasks
## ex: make task lint
task: ## Run task
	make run CMD="npm run $(filter-out $@,$(MAKECMDGOALS))"

nvm: ## Install nvm: restart your terminal after nvm install
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM}/install.sh | bash

tags: # Npm version with push
	make run CMD="npm version $(filter-out $@,$(MAKECMDGOALS))"
	git push --follow-tags
