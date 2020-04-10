<img src="https://i.imgur.com/t8IkKoZl.png" width="200"/>

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-00607c.svg)](https://www.mineiros.io/ref=repo_terraform-github-repository)
[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-s3-bucket/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/terraform-aws-s3-bucket)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-s3-bucket/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-brightgreen.svg)](https://github.com/hashicorp/terraform/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# terraform-aws-s3-bucket Example

This example creates two secure AWS S3-Buckets using the `mineiros-io/s3-bucket/aws` module.

One bucket is the `app` bucket which could be used to store a single-page-applications static files.

The other bucket is a `log` bucket to store access logs from the app bucket and additional logs from
ELBs in two different regions. Lifecycle rules are set up on the log bucket to migrate older logs into
cheaper storage.

## About Mineiros
Mineiros is a [DevOps as a Service](https://mineiros.io/) Company based in Berlin, Germany.
We offer Commercial Support for all of our projects, just send us an email to [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:
- Terraform Modules for all types of infrastructure such as VPC's, Docker clusters,
databases, logging and monitoring, CI, etc.
- Complex Cloud- and Multi Cloud environments.
- Consulting & Training on AWS, Terraform and DevOps.

## Reporting Issues
We use GitHub [Issues](https://github.com/mineiros-io/terraform-aws-s3-bucket/issues) to track community reported issues and missing features.

## Contributing
Contributions are very welcome!
We use [Pull Requests](https://github.com/mineiros-io/terraform-aws-s3-bucket/pulls)
for accepting changes.
Please see our
[Contribution Guidelines](https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/CONTRIBUTING.md)
for full details.

## License
This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros
