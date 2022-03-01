[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-s3-bucket)

[![Build Status](https://github.com/mineiros-io/terraform-aws-s3-bucket/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-aws-s3-bucket/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-s3-bucket/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-s3-bucket

A [Terraform] base module for creating a secure [AWS S3-Bucket].

***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Bucket Configuration](#bucket-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
    - [S3 Access Points](#s3-access-points)
    - [S3 bucket-level Public Access Block Configuration](#s3-bucket-level-public-access-block-configuration)
    - [Cross Account Access Configuration](#cross-account-access-configuration)
    - [Cloudfront Origin Access Identity Access](#cloudfront-origin-access-identity-access)
    - [ELB Log Delivery](#elb-log-delivery)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation S3](#aws-documentation-s3)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `aws_s3_bucket` resource this module creates secure
buckets by default. While all security features can be disabled as needed, best practices
are pre-configured.

In addition to security, easy cross-account access can be granted to the objects
of the bucket enforcing `bucket-owner-full-control` ACL for objects created by other accounts.

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
  source  = "git@github.com:mineiros-io/terraform-aws-s3-bucket.git?ref=v0.6.0"
}
```

Advanced usage as found in [examples/secure-s3-bucket/main.tf] setting all required and optional arguments to their default values.

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Bucket Configuration

- [**`bucket`**](#var-bucket): *(Optional `string`)*<a name="var-bucket"></a>

  The name of the bucket. If omitted, Terraform will assign a random, unique name. Forces new resource.

- [**`bucket_prefix`**](#var-bucket_prefix): *(Optional `string`)*<a name="var-bucket_prefix"></a>

  Creates a unique bucket name beginning with the specified prefix. Conflicts with `bucket`. Forces new resource.

- [**`acl`**](#var-acl): *(Optional `string`)*<a name="var-acl"></a>

  The canned ACL to apply.

  Default is `"private"`.

- [**`policy`**](#var-policy): *(Optional `string`)*<a name="var-policy"></a>

  A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide].

  Default is `null`.

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  A mapping of tags to assign to the bucket.

  Default is `{}`.

- [**`force_destroy`**](#var-force_destroy): *(Optional `bool`)*<a name="var-force_destroy"></a>

  A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.

  Default is `false`.

- [**`acceleration_status`**](#var-acceleration_status): *(Optional `string`)*<a name="var-acceleration_status"></a>

  Sets the accelerate configuration of an existing bucket. Can be `Enabled` or `Suspended`.

- [**`request_payer`**](#var-request_payer): *(Optional `string`)*<a name="var-request_payer"></a>

  Specifies who should bear the cost of Amazon S3 data transfer. Can be either `BucketOwner` or `Requester`.
  By default, the owner of the S3 bucket would incur the costs of any data transfer.
  See [Requester Pays Buckets developer guide] for more information.

  Default is `"BucketOwner"`.

- [**`cors_rule`**](#var-cors_rule): *(Optional `object(cors)`)*<a name="var-cors_rule"></a>

  Specifying settings for Cross-Origin Resource Sharing (CORS) (documented below).

  Default is `{}`.

  The `cors` object accepts the following attributes:

  - [**`allowed_headers`**](#attr-cors_rule-allowed_headers): *(Optional `list(string)`)*<a name="attr-cors_rule-allowed_headers"></a>

    Specifies which headers are allowed.

    Default is `[]`.

  - [**`allowed_methods`**](#attr-cors_rule-allowed_methods): *(**Required** `list(string)`)*<a name="attr-cors_rule-allowed_methods"></a>

    Specifies which methods are allowed. Can be `GET`, `PUT`, `POST`, `DELETE` or `HEAD`.

  - [**`allowed_origins`**](#attr-cors_rule-allowed_origins): *(**Required** `list(string)`)*<a name="attr-cors_rule-allowed_origins"></a>

    Specifies which origins are allowed.

  - [**`expose_headers`**](#attr-cors_rule-expose_headers): *(Optional `list(string)`)*<a name="attr-cors_rule-expose_headers"></a>

    Specifies expose header in the response.

    Default is `[]`.

  - [**`max_age_seconds`**](#attr-cors_rule-max_age_seconds): *(Optional `number`)*<a name="attr-cors_rule-max_age_seconds"></a>

    Specifies time in seconds that browser can cache the response for a preflight request.

- [**`versioning`**](#var-versioning): *(Optional `bool`)*<a name="var-versioning"></a>

  Can also be of type `object`. When set to `true` versioning will be enabled. Specifies Versioning Configuration when passed as an object (documented below).

  Default is `false`.

  The object accepts the following attributes:

  - [**`enabled`**](#attr-versioning-enabled): *(Optional `bool`)*<a name="attr-versioning-enabled"></a>

    Once you version-enable a bucket, it can never return to an unversioned state.
    You can, however, suspend versioning on that bucket.

  - [**`mfa_delete`**](#attr-versioning-mfa_delete): *(Optional `bool`)*<a name="attr-versioning-mfa_delete"></a>

    Enable MFA delete for either change: the versioning state of your bucket or
    permanently delete an object version.

    Default is `false`.

- [**`logging`**](#var-logging): *(Optional `map(string)`)*<a name="var-logging"></a>

  Specifying a configuration for logging access logs (documented below).

  Default is `{}`.

  Each `` object in the map accepts the following attributes:

  - [**`target_bucket`**](#attr-logging-target_bucket): *(**Required** `string`)*<a name="attr-logging-target_bucket"></a>

    The name of the bucket that will receive the log objects.

  - [**`target_prefix`**](#attr-logging-target_prefix): *(Optional `string`)*<a name="attr-logging-target_prefix"></a>

    To specify a key prefix for log objects.

- [**`apply_server_side_encryption_by_default`**](#var-apply_server_side_encryption_by_default): *(Optional `map(string)`)*<a name="var-apply_server_side_encryption_by_default"></a>

  Specifying the server side encryption to apply to objects at rest (documented below).
  Default is to use `AES256` encryption.

  Each `` object in the map accepts the following attributes:

  - [**`sse_algorithm`**](#attr-apply_server_side_encryption_by_default-sse_algorithm): *(Optional `string`)*<a name="attr-apply_server_side_encryption_by_default-sse_algorithm"></a>

    The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`. Default applies when `kms_master_key_id` is specified, else `AES256`

    Default is `"aws:kms"`.

  - [**`kms_master_key_id`**](#attr-apply_server_side_encryption_by_default-kms_master_key_id): *(Optional `string`)*<a name="attr-apply_server_side_encryption_by_default-kms_master_key_id"></a>

    The AWS KMS master key ID used for the SSE-KMS encryption. The default `aws/s3` AWS KMS master key is used if this element is absent while the sse_algorithm is `aws:kms`.

    Default is `"null"`.

- [**`lifecycle_rules`**](#var-lifecycle_rules): *(Optional `list(lifecycle_rule)`)*<a name="var-lifecycle_rules"></a>

  Specifying various rules specifying object lifecycle management (documented below).

  Default is `[]`.

  Each `lifecycle_rule` object in the list accepts the following attributes:

  - [**`id`**](#attr-lifecycle_rules-id): *(Optional `string`)*<a name="attr-lifecycle_rules-id"></a>

    Unique identifier for the rule.

  - [**`prefix`**](#attr-lifecycle_rules-prefix): *(Optional `string`)*<a name="attr-lifecycle_rules-prefix"></a>

    Object key prefix identifying one or more objects to which the rule applies.

  - [**`tags`**](#attr-lifecycle_rules-tags): *(Optional `map(string)`)*<a name="attr-lifecycle_rules-tags"></a>

    Specifies object tags key and value.

  - [**`enabled`**](#attr-lifecycle_rules-enabled): *(**Required** `bool`)*<a name="attr-lifecycle_rules-enabled"></a>

    Specifies lifecycle rule status.

  - [**`abort_incomplete_multipart_upload_days`**](#attr-lifecycle_rules-abort_incomplete_multipart_upload_days): *(Optional `number`)*<a name="attr-lifecycle_rules-abort_incomplete_multipart_upload_days"></a>

    Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.

  - [**`expiration`**](#attr-lifecycle_rules-expiration): *(Optional `object(expiration)`)*<a name="attr-lifecycle_rules-expiration"></a>

    Specifies a period in the object's expire (documented below).

    The `expiration` object accepts the following attributes:

    - [**`date`**](#attr-lifecycle_rules-expiration-date): *(Optional `string`)*<a name="attr-lifecycle_rules-expiration-date"></a>

      Specifies the date after which you want the corresponding action to take effect.

    - [**`days`**](#attr-lifecycle_rules-expiration-days): *(Optional `string`)*<a name="attr-lifecycle_rules-expiration-days"></a>

      Specifies the number of days after object creation when the specific rule action takes effect.

    - [**`expired_object_delete_marker`**](#attr-lifecycle_rules-expiration-expired_object_delete_marker): *(Optional `bool`)*<a name="attr-lifecycle_rules-expiration-expired_object_delete_marker"></a>

      On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers.

  - [**`transition`**](#attr-lifecycle_rules-transition): *(Optional `object(transition)`)*<a name="attr-lifecycle_rules-transition"></a>

    Specifies a period in the object's transitions (documented below).

    The `transition` object accepts the following attributes:

    - [**`date`**](#attr-lifecycle_rules-transition-date): *(Optional `string`)*<a name="attr-lifecycle_rules-transition-date"></a>

      Specifies the date after which you want the corresponding action to take effect.

    - [**`days`**](#attr-lifecycle_rules-transition-days): *(Optional `number`)*<a name="attr-lifecycle_rules-transition-days"></a>

      Specifies the number of days after object creation when the specific rule action takes effect.

    - [**`storage_class`**](#attr-lifecycle_rules-transition-storage_class): *(**Required** `string`)*<a name="attr-lifecycle_rules-transition-storage_class"></a>

      Specifies the Amazon S3 storage class to which you want the object to transition.
      Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.

  - [**`noncurrent_version_expiration`**](#attr-lifecycle_rules-noncurrent_version_expiration): *(Optional `object(noncurrent_version_expiration)`)*<a name="attr-lifecycle_rules-noncurrent_version_expiration"></a>

    Specifies when noncurrent object versions expire (documented below).

    The `noncurrent_version_expiration` object accepts the following attributes:

    - [**`days`**](#attr-lifecycle_rules-noncurrent_version_expiration-days): *(**Required** `number`)*<a name="attr-lifecycle_rules-noncurrent_version_expiration-days"></a>

      Specifies the number of days an object's noncurrent object versions expire.

  - [**`noncurrent_version_transition`**](#attr-lifecycle_rules-noncurrent_version_transition): *(Optional `object(noncurrent_version_transition)`)*<a name="attr-lifecycle_rules-noncurrent_version_transition"></a>

    Specifies when noncurrent object versions transitions (documented below).
    At least one of `expiration`, `transition`, `noncurrent_version_expiration`, `noncurrent_version_transition` must be specified.

    The `noncurrent_version_transition` object accepts the following attributes:

    - [**`days`**](#attr-lifecycle_rules-noncurrent_version_transition-days): *(**Required** `number`)*<a name="attr-lifecycle_rules-noncurrent_version_transition-days"></a>

      Specifies the number of days an object's noncurrent object versions expire.

    - [**`storage_class`**](#attr-lifecycle_rules-noncurrent_version_transition-storage_class): *(**Required** `string`)*<a name="attr-lifecycle_rules-noncurrent_version_transition-storage_class"></a>

      Specifies the Amazon S3 storage class to which you want the noncurrent versions object to transition.
      Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.

### Extended Resource Configuration

#### S3 Access Points

- [**`access_points`**](#var-access_points): *(Optional `list(access_point)`)*<a name="var-access_points"></a>

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

  Each `access_point` object in the list accepts the following attributes:

  - [**`name`**](#attr-access_points-name): *(**Required** `string`)*<a name="attr-access_points-name"></a>

    The name you want to assign to this access point.

  - [**`account_id`**](#attr-access_points-account_id): *(Optional `string`)*<a name="attr-access_points-account_id"></a>

    The AWS account ID for the owner of the bucket for which you want to create an access point.
    Defaults to automatically determined account ID of the Terraform AWS provider.

  - [**`policy`**](#attr-access_points-policy): *(Optional `string`)*<a name="attr-access_points-policy"></a>

    A valid JSON document that specifies the policy that you want to apply to this access point.

  - [**`vpc_id`**](#attr-access_points-vpc_id): *(Optional `string`)*<a name="attr-access_points-vpc_id"></a>

    If set, this access point will only allow connections from the specified VPC ID.

  - [**`block_public_acls`**](#attr-access_points-block_public_acls): *(Optional `bool`)*<a name="attr-access_points-block_public_acls"></a>

    Whether Amazon S3 should block public ACLs for this bucket.
    Enabling this setting does not affect existing policies or ACLs.

    Default is `true`.

  - [**`block_public_policy`**](#attr-access_points-block_public_policy): *(Optional `bool`)*<a name="attr-access_points-block_public_policy"></a>

    Whether Amazon S3 should block public bucket policies for this bucket.
    Enabling this setting does not affect the existing bucket policy.
    If `true`:
      - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.

    Default is `true`.

  - [**`ignore_public_acls`**](#attr-access_points-ignore_public_acls): *(Optional `bool`)*<a name="attr-access_points-ignore_public_acls"></a>

    Whether Amazon S3 should ignore public ACLs for this bucket.
    Enabling this setting does not affect the persistence of any existing ACLs and
    doesn't prevent new public ACLs from being set.
    If `true`:
      - Ignore public ACLs on this bucket and any objects that it contains.

    Default is `true`.

  - [**`restrict_public_buckets`**](#attr-access_points-restrict_public_buckets): *(Optional `bool`)*<a name="attr-access_points-restrict_public_buckets"></a>

    Whether Amazon S3 should restrict public bucket policies for this bucket.
    Enabling this setting does not affect the previously stored bucket policy,
    except that public and cross-account access within the public bucket policy,
    including non-public delegation to specific accounts, is blocked.
    If `true`:
      - Only the bucket owner and AWS Services can access this buckets if it has a public policy.

    Default is `true`.

#### S3 bucket-level Public Access Block Configuration

- [**`block_public_acls`**](#var-block_public_acls): *(Optional `bool`)*<a name="var-block_public_acls"></a>

  Whether Amazon S3 should block public ACLs for this bucket.
  Enabling this setting does not affect existing policies or ACLs.
  If `true`:
    - `PUT Bucket acl` and `PUT Object acl` calls will fail if the specified ACL allows public access.
    - `PUT Object` calls will fail if the request includes an object ACL.

  Default is `true`.

- [**`block_public_policy`**](#var-block_public_policy): *(Optional `bool`)*<a name="var-block_public_policy"></a>

  Whether Amazon S3 should block public bucket policies for this bucket.
  Enabling this setting does not affect the existing bucket policy.
  If `true`:
    - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.

  Default is `true`.

- [**`ignore_public_acls`**](#var-ignore_public_acls): *(Optional `bool`)*<a name="var-ignore_public_acls"></a>

  Whether Amazon S3 should ignore public ACLs for this bucket.
  Enabling this setting does not affect the persistence of any existing ACLs and
  doesn't prevent new public ACLs from being set.
  If `true`:
    - Ignore public ACLs on this bucket and any objects that it contains.

  Default is `true`.

- [**`restrict_public_buckets`**](#var-restrict_public_buckets): *(Optional `bool`)*<a name="var-restrict_public_buckets"></a>

  Whether Amazon S3 should restrict public bucket policies for this bucket.
  Enabling this setting does not affect the previously stored bucket policy,
  except that public and cross-account access within the public bucket policy,
  including non-public delegation to specific accounts, is blocked.
  If `true`:
    - Only the bucket owner and AWS Services can access this buckets if it has a public policy.

  Default is `true`.

#### Cross Account Access Configuration

- [**`cross_account_identifiers`**](#var-cross_account_identifiers): *(Optional `list(string)`)*<a name="var-cross_account_identifiers"></a>

  Specifies identifiers that should be granted cross account access to.
  If this list is empty Cross Account Access is not configured and all other
  options in this category are ignored.

  Default is `[]`.

- [**`cross_account_bucket_actions`**](#var-cross_account_bucket_actions): *(Optional `list(string)`)*<a name="var-cross_account_bucket_actions"></a>

  Specifies actions on the bucket to grant from cross account.

  Default is `["s3:ListBucket"]`.

- [**`cross_account_object_actions`**](#var-cross_account_object_actions): *(Optional `list(string)`)*<a name="var-cross_account_object_actions"></a>

  Specifies actions on bucket objects to grant from cross account.

  Default is `["s3:GetObject"]`.

- [**`cross_account_object_actions_with_forced_acl`**](#var-cross_account_object_actions_with_forced_acl): *(Optional `list(string)`)*<a name="var-cross_account_object_actions_with_forced_acl"></a>

  Specifies actions on bucket objects to grant only with foreced ACL from cross account.

  Default is `["s3:PutObject","s3:PutObjectAcl"]`.

- [**`cross_account_forced_acls`**](#var-cross_account_forced_acls): *(Optional `list(string)`)*<a name="var-cross_account_forced_acls"></a>

  Specifies ACLs to force on new objects for cross account access.

  Default is `["bucket-owner-full-control"]`.

#### Cloudfront Origin Access Identity Access

- [**`create_origin_access_identity`**](#var-create_origin_access_identity): *(Optional `bool`)*<a name="var-create_origin_access_identity"></a>

  Specifies whether to create and origin access identity and grant it access to read
  from the bucket. This can be used to grant a Cloudfront Distribution access to
  bucket objects when specifying this bucket as an origin.
  The Cloudfront Distribution must be in the same account.
  For cross account access create the OAI in the account of the cloudfront distribution and use
  `origin_acesss_identities` attribute to enable access.
  **Attention:** Objects shared that way need
  to be owned by the account the bucket belongs to and can not be owned by other accounts
  (e.g. when uploaded through cross-account-access).

  Default is `false`.

- [**`origin_acesss_identities`**](#var-origin_acesss_identities): *(Optional `list(string)`)*<a name="var-origin_acesss_identities"></a>

  Specify a list of Cloudfront OAIs to grant read-only access to.
  If in addition a new origin access identity is created via the `create_origin_access_identity`
  attribute, all identities will be granted access.
  **Attention:** Objects shared that way need
  to be owned by the account the bucket belongs to and can not be owned by other accounts
  (e.g. when uploaded through cross-account-access).

  Default is `[]`.

#### ELB Log Delivery

- [**`elb_log_delivery`**](#var-elb_log_delivery): *(Optional `bool`)*<a name="var-elb_log_delivery"></a>

  Allow delivery of logs from Elastic Loadbalancers (ELB).

- [**`elb_regions`**](#var-elb_regions): *(Optional `list(string)`)*<a name="var-elb_regions"></a>

  The names of the region whose AWS ELB account IDs are desired.
  Default is the region from the AWS provider configuration.

  Default is `[]`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
  overwritten by resource-specific tags.

  Default is `{}`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(object)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

## Module Outputs

The following attributes are exported by the module:

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`bucket`**](#output-bucket): *(`object(bucket)`)*<a name="output-bucket"></a>

  All bucket attributes as returned by the `aws_s3_bucket` resource
  containing all arguments as specified above and the other attributes as
  specified below.

- [**`id`**](#output-id): *(`string`)*<a name="output-id"></a>

  The name of the bucket.

- [**`arn`**](#output-arn): *(`string`)*<a name="output-arn"></a>

  The ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`.

- [**`bucket_domain_name`**](#output-bucket_domain_name): *(`string`)*<a name="output-bucket_domain_name"></a>

  The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`.

- [**`bucket_regional_domain_name`**](#output-bucket_regional_domain_name): *(`string`)*<a name="output-bucket_regional_domain_name"></a>

  The bucket region-specific domain name. The bucket domain name including
  the region name, please refer here for format. Note: The AWS CloudFront
  allows specifying S3 region-specific endpoint when creating S3 origin,
  it will prevent redirect issues from CloudFront to S3 Origin URL.

- [**`hosted_zone_id`**](#output-hosted_zone_id): *(`string`)*<a name="output-hosted_zone_id"></a>

  The Route 53 Hosted Zone ID for this bucket's region.

- [**`region`**](#output-region): *(`string`)*<a name="output-region"></a>

  The AWS region this bucket resides in.

- [**`bucket_policy`**](#output-bucket_policy): *(`object(bucket_policy)`)*<a name="output-bucket_policy"></a>

  All bucket policy object attributes as returned by the `s3_bucket_policy`
  resource.

- [**`origin_access_identity`**](#output-origin_access_identity): *(`object(origin_access_identity)`)*<a name="output-origin_access_identity"></a>

  All cloudfront origin access identity object attributes as returned by
  the `aws_cloudfront_origin_access_identity` resource.

- [**`access_point`**](#output-access_point): *(`list(access_point)`)*<a name="output-access_point"></a>

  A list of `aws_s3_access_point` objects keyed by the `name` attribute.

## External Documentation

### AWS Documentation S3

- Access Points: https://docs.aws.amazon.com/AmazonS3/latest/dev/access-points.html
- Default Encryption: https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
- Optimizing Performance: https://docs.aws.amazon.com/AmazonS3/latest/dev/optimizing-performance.html
- Requester Pays Bucket: https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html
- Security: https://docs.aws.amazon.com/AmazonS3/latest/dev/security.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_access_point
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-s3-bucket
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-s3-bucket/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[build-status]: https://github.com/mineiros-io/terraform-aws-s3-bucket/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-s3-bucket/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[Terraform]: https://www.terraform.io
[AWS S3-Bucket]: https://aws.amazon.com/s3/
[Semantic Versioning (SemVer)]: https://semver.org/
[AWS IAM Policy Document Guide]: https://learn.hashicorp.com/terraform/aws/iam-policy
[Requester Pays Buckets developer guide]: https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html
[examples/secure-s3-bucket/main.tf]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/examples/secure-s3-bucket/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-s3-bucket/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-s3-bucket/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/CONTRIBUTING.md
