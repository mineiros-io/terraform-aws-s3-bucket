# Terraform Module for creating a secure S3-Bucket

## Features
In contrast to the plain `aws_s3_bucket` resource this module creates secure
buckets by default. While all security features can be disabled as needed best practices
are pre-configured.

In addition to security easy cross-account access can be granted to the objects
of the bucket enforcing `bucket-owner-full-control` acl for objects created by other accounts.

### Default Security Settings
- :heavy_check_mark: Bucket public access blocking all set to `true` by default
- :heavy_check_mark: Server-Side-Encryption (SSE) at rest `enabled` by default (AES256)
- :heavy_check_mark: Bucket ACL defaults to canned `private` ACL

### Standard S3 Features
- :heavy_check_mark: Server-Side-Encryption (SSE) enabled by default
- :heavy_check_mark: Versioning
- :heavy_check_mark: Bucket Logging
- :heavy_check_mark: Lifecycle Rules
- :heavy_check_mark: Request Payer
- :heavy_check_mark: Cross-Origin Resource Sharing (CORS)
- :heavy_check_mark: Acceleration Status
- :heavy_check_mark: Bucket Policy
- :heavy_check_mark: Tags
- :x: Replication Configuration (not yet implemented)
- :x: Website Configuration (not yet implemented)
- :x: S3 Object Locking (not yet implemented)

### Extended S3 Features
- :heavy_check_mark: Bucket Public Access Blocking defaulting to `true`
- :x: Bucket Notifications (not yet implemented)
- :x: Bucket Metrics (not yet implemented)
- :x: Bucket Inventory (not yet implemented)
- :x: S3 Access Points (not yet supported by terraform aws provider :warning:)

### Additional Features
- :heavy_check_mark: Cross-Account access policy with forced `bucket-owner-full-control` ACL for direct access
- :x: Cloudfront Origin Access Identity (OAI) policy
- :x: Generate Cross-Account role for OAI enabled buckets if desired
- :x: Generate KMS key to encrypt objects at rest if desired
