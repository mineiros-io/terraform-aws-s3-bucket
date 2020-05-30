<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-vertial-logo-smaller-font.svg" width="200"/>

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-f32752.svg)](https://mineiros.io/?ref=repo_terraform-github-repository)
[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-s3-bucket/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/terraform-aws-s3-bucket)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-s3-bucket/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-brightgreen.svg)](https://github.com/hashicorp/terraform/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# terraform-aws-s3-bucket

A [Terraform](https://www.terraform.io) 0.12 base module for
[creating a secure S3-Bucket](https://aws.amazon.com/s3/) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
- [Module Attributes Reference](#module-attributes-reference)
- [Module Versioning](#module-versioning)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [License](#license)

## Module Features
In contrast to the plain `aws_s3_bucket` resource this module creates secure
buckets by default. While all security features can be disabled as needed best practices
are pre-configured.

In addition to security easy cross-account access can be granted to the objects
of the bucket enforcing `bucket-owner-full-control` acl for objects created by other accounts.

- **Default Security Settings**:
  Bucket public access blocking all set to `true` by default,
  Server-Side-Encryption (SSE) at rest `enabled` by default (AES256),
  Bucket ACL defaults to canned `private` ACL

- **Standard S3 Features**:
  Server-Side-Encryption (SSE) enabled by default,
  Versioning,
  Bucket Logging,
  Lifecycle Rules,
  Request Payer,
  Cross-Origin Resource Sharing (CORS),
  Acceleration Status,
  Bucket Policy,
  Tags

- **Extended S3 Features**:
  Bucket Public Access Blocking,
  S3 Access Points

- **Additional Features**:
  Cross-Account access policy with forced `bucket-owner-full-control` ACL for direct access,
  Create Cloudfront Origin Access Identity (OAI) and grant read-only access,
  Grant read-only access to existing Cloudfront Origin Access Identity (OAI),
  Allow ELB log delivery

- *Features not yet implemented*:
  Enforce Encryption via a policy that blocks unencrypted uploads,
  ACL policy grants (aws-provider >= 2.52.0),
  Amazon S3 Analytics (aws-provider >= 2.49.0),
  Replication Configuration,
  Website Configuration,
  S3 Object Locking,
  Bucket Notifications,
  Bucket Metrics,
  Bucket Inventory,
  Generate Cross-Account role for OAI enabled buckets if desired,
  Generate KMS key to encrypt objects at rest if desired

## Getting Started
Most basic usage creating a random named secure AWS bucket.

```hcl
module "bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.1.2"
}
```

## Module Argument Reference
See [variables.tf](variables.tf) and [examples/](examples) for details and use-cases.

#### Module Configuration
- **`module_enabled`**: *(Optional `bool`)*
Specifies whether resources in the module will be created.
Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*
A list of dependencies. Any object can be assigned to this list to define a hidden
external dependency.

#### Top-level Arguments

##### Bucket Configuration
- **`bucket`**: *(Optional `string`, Forces new resource)*
The name of the bucket. If omitted, Terraform will assign a random, unique name.

- **`bucket_prefix`**: *(Optional `string`, Forces new resource)*
Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket.

- **`acl`**: *(Optional `string`)*
The canned ACL to apply.
Defaults to `private`.

- **`policy`**: *(Optional `json string`)*
A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide.
Default is `null`.

- **`tags`**: *(Optional `map(string)`)*
A mapping of tags to assign to the bucket.
Default is `{}`.

- **`force_destroy`**: *(Optional `bool`)*
A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.
Default is `false`.

- **`acceleration_status`**: *(Optional `string`)*
Sets the accelerate configuration of an existing bucket. Can be `Enabled` or `Suspended`.
Default is `null`.

- **`region`**: *(Optional `string`)*
If specified, the AWS region this bucket should reside in.
Default is the region used by the callee.

- **`request_payer`**: *(Optional `string`)*
Specifies who should bear the cost of Amazon S3 data transfer. Can be either `BucketOwner` or `Requester`.
By default, the owner of the S3 bucket would incur the costs of any data transfer.
See Requester Pays Buckets developer guide for more information.

- **[`cors_rule`](#cors_rule-object-attributes)**: *(Optional `object`)*
specifying settings for Cross-Origin Resource Sharing (CORS) (documented below).
Default is `{}`.

- **[`versioning`](#versioning-object-attributes)**: *(Optional `bool` or `object`)*
When set to `true` versioning will be enabled. Specifies Versioning Configuration when passed as an object (documented below).
Default is `false`.

- **[`logging`](#logging-object-attributes)**: *(Optional `object`)*
Specifying a configuration for logging access logs (documented below).
Default is `{}`.

- **[`apply_server_side_encryption_by_default`](#apply_server_side_encryption_by_default-object-attributes)**:
*(Optional `object`)*
Specifying the server side encryption to apply to objects at rest (documented below).
Default is to use `AES256` encryption.

- **[`lifecycle_rules`](#lifecycle_rules-object-attributes)**: *(Optional `list(object)`)*
Specifying various rules specifying object lifecycle management (documented below).
Default is `[]`.

##### S3 Access Points
- **[`access_points`](#access_point-object-attributes)**: *(Optional `list(access_point)`)*
Amazon S3 Access Points simplify managing data access at scale for shared datasets in S3.
Access points are named network endpoints that are attached to buckets that
you can use to perform S3 object operations, such as `GetObject` and `PutObject`.
Each access point has distinct permissions and network controls that S3 applies
for any request that is made through that access point.
Each access point enforces a customized access point policy that works in
conjunction with the bucket policy that is attached to the underlying bucket.
You can configure any access point to accept requests only from a
virtual private cloud (VPC) to restrict Amazon S3 data access to a private network.
You can also configure custom block public access settings for each access point.
Default is `[]`.

##### S3 bucket-level Public Access Block configuration
- **`block_public_acls`**: *(Optional `bool`)*
Whether Amazon S3 should block public ACLs for this bucket.
Enabling this setting does not affect existing policies or ACLs.
Default is `true` causing the following behavior:
  - `PUT Bucket acl` and `PUT Object acl` calls will fail if the specified ACL allows public access.
  - `PUT Object` calls will fail if the request includes an object ACL.

- **`block_public_policy`**: *(Optional `bool`)*
Whether Amazon S3 should block public bucket policies for this bucket.
Enabling this setting does not affect the existing bucket policy.
Defaults to `true` causing Amazon S3 to:
  - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.

- **`ignore_public_acls`**: *(Optional `bool`)*
Whether Amazon S3 should ignore public ACLs for this bucket.
Enabling this setting does not affect the persistence of any existing ACLs and
doesn't prevent new public ACLs from being set.
Defaults to `true` causing Amazon S3 to:
  - Ignore public ACLs on this bucket and any objects that it contains.

- **`restrict_public_buckets`**: *(Optional `bool`)*
Whether Amazon S3 should restrict public bucket policies for this bucket.
Enabling this setting does not affect the previously stored bucket policy,
except that public and cross-account access within the public bucket policy,
including non-public delegation to specific accounts, is blocked.
Default is `true` causing the following effect:
  - Only the bucket owner and AWS Services can access this buckets if it has a public policy.

##### Cross Account Access Configuration
- **`cross_account_identifiers`**: *(Optional `list(sring)`)*
Specifies identifiers that should be granted cross account access to.
If this list is empty Cross Account Access is not configured and all other
options in this category are ignored.
Default is `[]` (disabled).

- **`cross_account_bucket_actions`**: *(Optional `list(string)`)*
Specifies actions on the bucket to grant from cross account.
Default is `["s3:ListBucket"]`.

- **`cross_account_object_actions`**: *(Optional `list(string)`)*
Specifies actions on bucket objects to grant from cross account.
Default is `["s3:GetObject"]`.

- **`cross_account_object_actions_with_forced_acl`**: *(Optional `list(string)`)*
Specifies actions on bucket objects to grant only with foreced ACL from cross account.
Default is `["s3:PutObject", "s3:PutObjectAcl"]`.

- **`cross_account_forced_acls`**: *(Optional `list(string)`)*
Specifies ACLs to force on new objects for cross account access.
Default is `["bucket-owner-full-control"]`.

##### Cloudfront Origin Access Identity Access
- **`create_origin_access_identity`**: *(Optional `bool`)*
Specifies whether to create and origin access identity and grant it access to read
from the bucket. This can be used to grant a cloudfront distribution access to
bucket objects when specifying this bucket as an origin.
The Cloudfront distribution must be in the same account.
For cross account access create the OAI in the account of the cloudfront distribution and use
`origin_acesss_identities` attribute to enable access.
**Attention:** Objects shared that way need
to be owned by the account the bucket belongs to and can not be owned by other accounts
(e.g. when uploaded through cross-account-access).
Default is `false` (disabled).

- **`origin_acesss_identities`**: *(Optional `list(string)`)*
Specify a list of cloudfront origin access identities to grant read-only access to.
If in addition a new origin access identity is created via the `create_origin_access_identity`
attribute, all identities will be granted access. **Attention:** Objects shared that way need
to be owned by the account the bucket belongs to and can not be owned by other accounts
(e.g. when uploaded through cross-account-access).

##### ELB log delivery
- **`elb_log_delivery`**: *(Optional `bool`)*
Allow delivery of logs from Elastic Loadbalancers (ELB).
Default is `true` if `acl` attribute is set to `"log-delivery-write"` or
`elb_regions` is explicitly set, else default is `false`.

- **`elb_regions`**: *(Optional `list(string)`*
The names of the region whose AWS ELB account IDs are desired.
Default is the region from the AWS provider configuration.

#### [`cors_rule`](#bucket-configuration) Object Attributes
- **`allowed_headers`**: *(Optional `list(string)`)*
Specifies which headers are allowed.
Default is `[]`.

- **`allowed_methods`**: ***(Required `list(string)`)***
Specifies which methods are allowed. Can be `GET`, `PUT`, `POST`, `DELETE` or `HEAD`.

- **`allowed_origins`**: ***(Required `list(string)`)***
Specifies which origins are allowed.

- **`expose_headers`**: *(Optional `list(string)`)*
Specifies expose header in the response.
Default is `[]`.

- **`max_age_seconds`**: *(Optional `number`)*
Specifies time in seconds that browser can cache the response for a preflight request.
Default is `null`.

#### [`versioning`](#bucket-configuration) Object Attributes
- **`enabled`**: *(Optional `bool`)*
Once you version-enable a bucket, it can never return to an unversioned state.
You can, however, suspend versioning on that bucket.
Default is `null`.

- **`mfa_delete`**: *(Optional `bool`)*
Enable MFA delete for either Change the versioning state of your bucket or
permanently delete an object version.
Default is `false`.

#### [`logging`](#bucket-configuration) Object Attributes
- **`target_bucket`**: ***(Required `string`)***
The name of the bucket that will receive the log objects.

- **`target_prefix`**: *(Optional `string`)*
To specify a key prefix for log objects.
Default is `null`.

#### [`apply_server_side_encryption_by_default`](#bucket-configuration) Object Attributes
- **`sse_algorithm`**: *(Optional `string`)*
The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`.
Default is `aws:kms` when `kms_master_key_id` is specified else `AES256`

- **`kms_master_key_id`**: *(Optional `string`)*
The AWS KMS master key ID used for the SSE-KMS encryption. The default `aws/s3` AWS KMS master key is used if this element is absent while the sse_algorithm is `aws:kms`.
Default is `null`.

#### [`lifecycle_rules`](#bucket-configuration) Object Attributes
- **`id`**: *(Optional `string`)*
Unique identifier for the rule.

- **`prefix`**: *(Optional `string`)*
Object key prefix identifying one or more objects to which the rule applies.

- **`tags`**: *(Optional `map`)*
Specifies object tags key and value.

- **`enabled`**: ***(Required `bool`)***
Specifies lifecycle rule status.

- **`abort_incomplete_multipart_upload_days`**: *(Optional `number`)*
Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.

- **[`expiration`](#expiration-object-attributes)**: *(Optional `object`)*
Specifies a period in the object's expire (documented below).

- **[`transition`](#transition-object-attributes)**: *(Optional `object`)*
Specifies a period in the object's transitions (documented below).

- **[`noncurrent_version_expiration`](#noncurrent_version_expiration-object-attributes)**:
*(Optional `object`)*
Specifies when noncurrent object versions expire (documented below).

- **[`noncurrent_version_transition`](#noncurrent_version_transition-object-attributes)**:
*(Optional `object`)*
Specifies when noncurrent object versions transitions (documented below).

At least one of `expiration`, `transition`, `noncurrent_version_expiration`, `noncurrent_version_transition` must be specified.

##### [`expiration`](#lifecycle_rules-object-attributes) Object Attributes
- **`date`**: *(Optional `string`)*
Specifies the date after which you want the corresponding action to take effect.

- **`days`**: *(Optional `string`)*
Specifies the number of days after object creation when the specific rule action takes effect.

- **`expired_object_delete_marker`**: *(Optional `bool`)*
On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers.

##### [`transition`](#lifecycle_rules-object-attributes) Object Attributes
- **`date`**: *(Optional `string`)*
Specifies the date after which you want the corresponding action to take effect.

- **`days`**: *(Optional `number`)*
Specifies the number of days after object creation when the specific rule action takes effect.

- **`storage_class`**: ***(Required `string`)***
Specifies the Amazon S3 storage class to which you want the object to transition.
Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.

##### [`noncurrent_version_expiration`](#lifecycle_rules-object-attributes) Object Attributes
- **`days`**: ***(Required `number`)***
Specifies the number of days an object is noncurrent object versions expire.

##### [`noncurrent_version_transition`](#lifecycle_rules-object-attributes) Object Attributes
- **`days`**: ***(Required `number`)***
Specifies the number of days an object is noncurrent object versions expire.

- **`storage_class`**: ***(Required `string`)***
Specifies the Amazon S3 storage class to which you want the noncurrent versions object to transition.
Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.

#### [`access_point`](#s3-access-points) Object Attributes
- **`name`**: ***(Required `string`)***
The name you want to assign to this access point.

- **`account_id`**: *(Optional `string`)*
The AWS account ID for the owner of the bucket for which you want to create an access point.
Defaults to automatically determined account ID of the Terraform AWS provider.

- **`policy`**: *(Optional `string`)*
A valid JSON document that specifies the policy that you want to apply to this access point.

- **`vpc_id`**: *(Optional `string`)*
If set, this access point will only allow connections from the specified VPC ID.

- **`block_public_acls`**: *(Optional `bool`)*
Whether Amazon S3 should block public ACLs for this bucket.
Enabling this setting does not affect existing policies or ACLs.
Default is `true` causing the following behavior:
  - `PUT Bucket acl` and `PUT Object acl` calls will fail if the specified ACL allows public access.
  - `PUT Object` calls will fail if the request includes an object ACL.

- **`block_public_policy`**: *(Optional `bool`)*
Whether Amazon S3 should block public bucket policies for this bucket.
Enabling this setting does not affect the existing bucket policy.
Defaults to `true` causing Amazon S3 to:
  - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.

- **`ignore_public_acls`**: *(Optional `bool`)*
Whether Amazon S3 should ignore public ACLs for this bucket.
Enabling this setting does not affect the persistence of any existing ACLs and
doesn't prevent new public ACLs from being set.
Defaults to `true` causing Amazon S3 to:
  - Ignore public ACLs on this bucket and any objects that it contains.

- **`restrict_public_buckets`**: *(Optional `bool`)*
Whether Amazon S3 should restrict public bucket policies for this bucket.
Enabling this setting does not affect the previously stored bucket policy,
except that public and cross-account access within the public bucket policy,
including non-public delegation to specific accounts, is blocked.
Default is `true` causing the following effect:
  - Only the bucket owner and AWS Services can access this buckets if it has a public policy.

## Module Attributes Reference
The following attributes are exported by the module:

- **`module_enabled`**: The `module_enabled` argument.
- **`bucket`**: All bucket attributes as returned by the
[`aws_s3_bucket`](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#attributes-reference) resource
containing all arguments as specified above and the other attributes as specified below.
  - **`id`**: The name of the bucket.
  - **`arn`**: The ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`.
  - **`bucket_domain_name`**: The bucket domain name. Will be of format bucketname.s3.amazonaws.com.
  - **`bucket_regional_domain_name`**: The bucket region-specific domain name.
    The bucket domain name including the region name, please refer here for format.
    Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin,
    it will prevent redirect issues from CloudFront to S3 Origin URL.
  - **`hosted_zone_id`**: The Route 53 Hosted Zone ID for this bucket's region.
  - **`region`**: The AWS region this bucket resides in.
- **`bucket_policy`**: All bucket policy object attributes as returned by the
[`s3_bucket_policy`](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html#argument-reference) resource.
- **`origin_access_identity`**: All cloudfront origin access identity object attributes as returned by the
[`aws_cloudfront_origin_access_identity`](https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html#attribute-reference) resource.
- **`access_point`**: A list of
[`aws_s3_access_point`](https://www.terraform.io/docs/providers/aws/r/s3_access_point.html#attributes-reference) objects keyed by the `name` attribute.

## Module Versioning
This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Given a version number `MAJOR.MINOR.PATCH`, we increment the:
1) `MAJOR` version when we make incompatible changes,
2) `MINOR` version when we add functionality in a backwards compatible manner, and
3) `PATCH` version when we make backwards compatible bug fixes.

#### Backwards compatibility in `0.0.z` and `0.y.z` version
- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

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
