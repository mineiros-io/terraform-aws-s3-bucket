#!/usr/bin/env make

TARGET_MOUNT_DIRECTORY = /app/src

# set required build variables if env variables aren't set yet
ifndef BUILD_VERSION
	BUILD_VERSION := latest
endif

ifndef BUILD_TOOLS
	BUILD_TOOLS := mineiros/build-tools
endif

ifndef DOCKER_IMAGE
	DOCKER_IMAGE := ${BUILD_TOOLS}:${BUILD_VERSION}
endif

ifndef TERRAFORM_PLAN_FILENAME
	TERRAFORM_PLAN_FILENAME := tfplan
endif

# Run pre-commit hooks
docker-run-pre-commit-hooks:
	docker run --rm \
		-v ${PWD}:${TARGET_MOUNT_DIRECTORY} \
		${DOCKER_IMAGE} \
		sh -c "pre-commit install && pre-commit run --all-files"

# Run terraform plan
docker-run-terraform-plan:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e GITHUB_TOKEN \
		-e GITHUB_ORGANIZATION \
		-v ${PWD}:${TARGET_MOUNT_DIRECTORY} \
		${DOCKER_IMAGE} \
		sh -c "terraform init -input=false && terraform plan -input=false"

# Run terraform apply
docker-run-terraform-apply:
	docker run --rm \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e GITHUB_TOKEN \
		-e GITHUB_ORGANIZATION \
		-v ${PWD}:${TARGET_MOUNT_DIRECTORY} \
		${DOCKER_IMAGE} \
		sh -c "terraform init -input=false && \
		terraform plan -out=${TERRAFORM_PLAN} -input=false &&  \
		terraform apply -input=false -auto-approve ${TERRAFORM_PLAN}"

.PHONY: docker-run-pre-commit-hooks docker-run-terraform-plan docker-run-terraform-apply

