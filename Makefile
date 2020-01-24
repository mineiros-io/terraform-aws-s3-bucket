MOUNT_TARGET_DIRECTORY  = /app/src
BUILD_TOOLS_DOCKER_REPO = mineiros/build-tools
DOCKER                  = $(shell which docker)

# Set default value for environment variable if there aren't set already
ifndef BUILD_TOOLS_VERSION
	BUILD_TOOLS_VERSION := latest
endif

ifndef BUILD_TOOLS_DOCKER_IMAGE
	BUILD_TOOLS_DOCKER_IMAGE := ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}
endif

ifndef TERRAFORM_PLAN_FILENAME
	TERRAFORM_PLAN_FILENAME := tfplan
endif

## Display help for all targets
help:
	@awk '/^[a-zA-Z_0-9%:\\\/-]+:/ { \
		msg = match(lastLine, /^## (.*)/); \
			if (msg) { \
				cmd = $$1; \
				msg = substr(lastLine, RSTART + 3, RLENGTH); \
				gsub("\\\\", "", cmd); \
				gsub(":+$$", "", cmd); \
				printf "  \x1b[32;01m%-35s\x1b[0m %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u

.DEFAULT_GOAL := help

## Mounts the working directory inside a docker container and runs the pre-commit hooks
docker-run-pre-commit-hooks: $(DOCKER)
	@$(DOCKER) run --rm \
		-v ${PWD}:${MOUNT_TARGET_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		sh -c "pre-commit install && pre-commit run --all-files"

## Mounts the working directory inside a new container and runs the Go tests. Requires $AWS_ACCESS_KEY_ID and $AWS_SECRET_ACCESS_KEY to be set
docker-run-unit-tests: $(DOCKER)
	@$(DOCKER) run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-v ${PWD}:${MOUNT_TARGET_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		go test -v test/terraform_aws_s3_bucket_test.go

.PHONY: help docker-run-pre-commit-hooks docker-run-tests

