# Terraform Module for creating a secure S3-Bucket

## Features
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
  Bucket Public Access Blocking defaulting to `true`

- **Additional Features**:
  Cross-Account access policy with forced `bucket-owner-full-control` ACL for direct access

- *Features not yet implemented*:
  Replication Configuration,
  Website Configuration,
  S3 Object Locking,
  Bucket Notifications,
  Bucket Metrics,
  Bucket Inventory,
  S3 Access Points (not yet supported by terraform aws provider),
  Cloudfront Origin Access Identity (OAI) policy,
  Generate Cross-Account role for OAI enabled buckets if desired,
  Generate KMS key to encrypt objects at rest if desired
