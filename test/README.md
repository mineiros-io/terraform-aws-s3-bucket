# Tests
This directory contains a number of automated tests that cover the functionality of the modules that ship with this 
repository.

## Introduction
We are using [Terratest](https://github.com/gruntwork-io/terratest) for automated tests of the examples.
Terratest deploys _real_ infrastructure (e.g., servers) in a *real* environment (e.g., AWS).

The basic usage pattern for writing automated tests with Terratest is to:

1.  Write tests using Go's built-in [package testing](https://golang.org/pkg/testing/): you create a file ending in
    `_test.go` and run tests with the `go test` command.
1.  Use Terratest to execute your _real_ IaC tools (e.g., Terraform, Packer, etc.) to deploy _real_ infrastructure
    (e.g., servers) in a _real_ environment (e.g., AWS).
1.  Validate that the infrastructure works correctly in that environment by making HTTP requests, API calls, SSH
    connections, etc.
1.  Undeploy everything at the end of the test.

**Note #1**: Many of these tests create real resources in an AWS account. That means they cost money to run, especially
if you don't clean up after yourself. Please be considerate of the resources you create and take extra care to clean
everything up when you're done!

**Note #2**: Never hit `CTRL + C` or cancel a build once tests are running or the cleanup tasks won't run!

**Note #3**: We set `-timeout 45m` on all tests not because they necessarily take 45 minutes, but because Go has a
default test timeout of 10 minutes, after which it does a `SIGQUIT`, preventing the tests from properly cleaning up
after themselves. Therefore, we set a timeout of 45 minutes to make sure all tests have enough time to finish and
cleanup.

## How to run the tests
This repository comes with a Dockerfile and a Makefile, that help you to run the tests in a convenient way.
Alternatively, you can also run the tests without Docker.

### Run the tests with Docker
1. Install [Docker](https://docs.docker.com/get-started/)
1. Set your AWS credentials as environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
1. Run `make docker-run-tests`

### Run the tests without Docker
1. Install the latest version of [Go](https://golang.org/).
1. Install [Terraform](https://www.terraform.io/downloads.html).
1. Set your AWS credentials as environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
1. Install go dependencies: `go mod download`
1. Run all tests: `go test -v -timeout 45m -parallel 128 test/`
1. Run a specific test: `go test -v -timeout 45m -parallel 128 test/example_test.go`
