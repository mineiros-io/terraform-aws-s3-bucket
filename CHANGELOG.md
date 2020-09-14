# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0]
### Changed
- Add support for Terraform 0.13.x.
- Add support for `module_tags`.

## [0.3.0] - 2020-08-03
### Changed
- Add support for 3.x terraform AWS provider

### Removed
- Remove deprecated `region` argument (BREAKING CHANGE)

## [0.2.2] - 2020-07-23
### Added
- Add Changelog.md.
### Changed
- Migrate CI from SemaphoreCI to GitHub Actions.
- Migrate to [golangci-lint](https://github.com/golangci/golangci-lint) instead
  of native go tools for pre-commit hooks.

## [0.2.1] - 2020-06-13
### Added
- Work around a terraform issue in `module_depends_on` argument.

## [0.2.0] - 2020-06-08
### Added
- Implement `module_enabled` and `module_depends_on` this replaces the `create` flag.
- This replaces the backward-incompatible v0.1.5 which we removed right after
  noticing the issue.
### Changed
- Upgrade documentation.
- Update build-system.

## [0.1.4] - 2020-04-14
### Added
- Add access point support.
### Changed
- Refactored examples.

## [0.1.3] - 2020-03-23
### Added
- Allow log delivery from ELBs in different regions.

## [0.1.2] - 2020-03-19
### Added
- Add ELB log delivery option to the module.

## [0.1.1] - 2020-03-04
### Added
- Add the option to grant read-only access to existing Cloudfront Origin Access
  Identities via `origin_access_identities`.

## [0.1.0] - 2020-02-29
### Added
- Add support for Origin Access Identity Access from Cloudfront.

## [0.0.3] - 2020-01-24
### Changed
- Update minimum Terraform version to 0.12.20,
  so we can take advantage of `try` and `can`.
- Update README.md with and align it with our new format.

## [0.0.2] - 2020-01-20
### Added
- SemaphoreCI Integration that will run build, pre-commit checks and unit tests.
- Add an example and a simple test case.
- Further elaboration in README.md.

## [0.0.1] - 2020-01-02
### Added
- Bucket public access blocking all set to true by default.
- Server-Side-Encryption (SSE) at rest enabled by default (AES256).
- Bucket ACL defaults to canned private ACL.
- Server-Side-Encryption (SSE) enabled by default
- Added support for Versioning, Bucket Logging, Lifecycle Rules, Request Payer,
  Cross-Origin Resource Sharing (CORS), Acceleration Status, Bucket Policy and Tags.

<!-- markdown-link-check-disable -->
[Unreleased]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.3.0...v0.4.0
<!-- markdown-link-check-enable -->
[0.3.0]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.1.4...v0.2.0
[0.1.4]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-aws-s3-bucket/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-s3-bucket/releases/tag/v0.0.1
