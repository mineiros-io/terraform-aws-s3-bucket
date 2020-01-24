#!/usr/bin/env make

TARGET_MOUNT_DIRECTORY  = /app/src
BUILD_TOOLS_DOCKER_REPO = mineiros/build-tools

ifndef BUILD_TOOLS_VERSION
	BUILD_TOOLS_VERSION := latest
endif

ifndef BUILD_TOOLS_DOCKER_IMAGE
	BUILD_TOOLS_DOCKER_IMAGE := ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}
endif

ifndef TERRAFORM_PLAN_FILENAME
	TERRAFORM_PLAN_FILENAME := tfplan
endif

# Run pre-commit hooks
docker-run-pre-commit-hooks:
	docker run --rm \
		-v ${PWD}:${TARGET_MOUNT_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		sh -c "pre-commit install && pre-commit run --all-files"

# Run Go tests
docker-run-tests:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-v ${PWD}:${TARGET_MOUNT_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		go test -v test/terraform_aws_s3_bucket_test.go

.PHONY: docker-run-pre-commit-hooks docker-run-tests

