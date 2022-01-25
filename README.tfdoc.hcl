header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-s3-bucket"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-s3-bucket/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-s3-bucket/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-s3-bucket/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-s3-bucket"
  toc     = true
  content = <<-END
    A [Terraform] base module for creating a secure [AWS S3-Bucket].

    ***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***
  END

  section {
    title   = "Module Features"
    content = <<-END
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
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage creating a random named secure AWS bucket.

      ```hcl
      module "bucket" {
        source  = "mineiros-io/s3-bucket/aws"
        version = "~> 0.6.0"
      }
      ```

      Advanced usage as found in [examples/secure-s3-bucket/main.tf] setting all required and optional arguments to their default values.
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Bucket Configuration"

      variable "bucket" {
        type        = string
        description = <<-END
          The name of the bucket. If omitted, Terraform will assign a random, unique name. Forces new resource.
        END
      }

      variable "bucket_prefix" {
        type        = string
        description = <<-END
          Creates a unique bucket name beginning with the specified prefix. Conflicts with `bucket`. Forces new resource.
        END
      }

      variable "acl" {
        type        = string
        default     = "private"
        description = <<-END
          The canned ACL to apply.
        END
      }

      variable "policy" {
        type        = string
        default     = null
        description = <<-END
          A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide].
        END
      }

      variable "tags" {
        type        = map(string)
        default     = {}
        description = <<-END
          A mapping of tags to assign to the bucket.
        END
      }

      variable "force_destroy" {
        type        = bool
        default     = false
        description = <<-END
          A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.
        END
      }

      variable "acceleration_status" {
        type        = string
        description = <<-END
          Sets the accelerate configuration of an existing bucket. Can be `Enabled` or `Suspended`.
        END
      }

      variable "request_payer" {
        type        = string
        default     = "BucketOwner"
        description = <<-END
          Specifies who should bear the cost of Amazon S3 data transfer. Can be either `BucketOwner` or `Requester`.
          By default, the owner of the S3 bucket would incur the costs of any data transfer.
          See [Requester Pays Buckets developer guide] for more information.
        END
      }

      variable "cors_rule" {
        type        = object(cors)
        default     = {}
        description = <<-END
          Specifying settings for Cross-Origin Resource Sharing (CORS) (documented below).
        END

        attribute "allowed_headers" {
          type        = list(string)
          default     = []
          description = <<-END
            Specifies which headers are allowed.
          END
        }

        attribute "allowed_methods" {
          required    = true
          type        = list(string)
          description = <<-END
            Specifies which methods are allowed. Can be `GET`, `PUT`, `POST`, `DELETE` or `HEAD`.
          END
        }

        attribute "allowed_origins" {
          required    = true
          type        = list(string)
          description = <<-END
            Specifies which origins are allowed.
          END
        }

        attribute "expose_headers" {
          type        = list(string)
          default     = []
          description = <<-END
            Specifies expose header in the response.
          END
        }

        attribute "max_age_seconds" {
          type        = number
          description = <<-END
            Specifies time in seconds that browser can cache the response for a preflight request.
          END
        }
      }

      variable "versioning" {
        type        = bool
        default     = false
        description = <<-END
          Can also be of type `object`. When set to `true` versioning will be enabled. Specifies Versioning Configuration when passed as an object (documented below).
        END

        attribute "enabled" {
          type        = bool
          description = <<-END
            Once you version-enable a bucket, it can never return to an unversioned state.
            You can, however, suspend versioning on that bucket.
          END
        }

        attribute "mfa_delete" {
          type        = bool
          default     = false
          description = <<-END
            Enable MFA delete for either change: the versioning state of your bucket or
            permanently delete an object version.
          END
        }
      }

      variable "logging" {
        type        = map(string)
        default     = {}
        description = <<-END
          Specifying a configuration for logging access logs (documented below).
        END

        attribute "target_bucket" {
          required    = true
          type        = string
          description = <<-END
            The name of the bucket that will receive the log objects.
          END
        }

        attribute "target_prefix" {
          type        = string
          description = <<-END
            To specify a key prefix for log objects.
          END
        }
      }

      variable "apply_server_side_encryption_by_default" {
        type        = map(string)
        description = <<-END
          Specifying the server side encryption to apply to objects at rest (documented below).
          Default is to use `AES256` encryption.
        END

        attribute "sse_algorithm" {
          type        = string
          default     = "aws:kms"
          description = <<-END
            The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`. Default applies when `kms_master_key_id` is specified, else `AES256`
          END
        }

        attribute "kms_master_key_id" {
          type        = string
          default     = "null"
          description = <<-END
            The AWS KMS master key ID used for the SSE-KMS encryption. The default `aws/s3` AWS KMS master key is used if this element is absent while the sse_algorithm is `aws:kms`.
          END
        }
      }

      variable "lifecycle_rules" {
        type        = list(lifecycle_rule)
        default     = []
        description = <<-END
          Specifying various rules specifying object lifecycle management (documented below).
        END

        attribute "id" {
          type        = string
          description = <<-END
            Unique identifier for the rule.
          END
        }

        attribute "prefix" {
          type        = string
          description = <<-END
            Object key prefix identifying one or more objects to which the rule applies.
          END
        }

        attribute "tags" {
          type        = map(string)
          description = <<-END
            Specifies object tags key and value.
          END
        }

        attribute "enabled" {
          required    = true
          type        = bool
          description = <<-END
            Specifies lifecycle rule status.
          END
        }

        attribute "abort_incomplete_multipart_upload_days" {
          type        = number
          description = <<-END
            Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.
          END
        }

        attribute "expiration" {
          type        = object(expiration)
          description = <<-END
            Specifies a period in the object's expire (documented below).
          END

          attribute "date" {
            type        = string
            description = <<-END
              Specifies the date after which you want the corresponding action to take effect.
            END
          }

          attribute "days" {
            type        = string
            description = <<-END
              Specifies the number of days after object creation when the specific rule action takes effect.
            END
          }

          attribute "expired_object_delete_marker" {
            type        = bool
            description = <<-END
              On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers.
            END
          }
        }

        attribute "transition" {
          type        = object(transition)
          description = <<-END
            Specifies a period in the object's transitions (documented below).
          END

          attribute "date" {
            type        = string
            description = <<-END
              Specifies the date after which you want the corresponding action to take effect.
            END
          }

          attribute "days" {
            type        = number
            description = <<-END
              Specifies the number of days after object creation when the specific rule action takes effect.
            END
          }

          attribute "storage_class" {
            required    = true
            type        = string
            description = <<-END
              Specifies the Amazon S3 storage class to which you want the object to transition.
              Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.
            END
          }
        }

        attribute "noncurrent_version_expiration" {
          type        = object(noncurrent_version_expiration)
          description = <<-END
            Specifies when noncurrent object versions expire (documented below).
          END

          attribute "days" {
            required    = true
            type        = number
            description = <<-END
              Specifies the number of days an object's noncurrent object versions expire.
            END
          }
        }

        attribute "noncurrent_version_transition" {
          type        = object(noncurrent_version_transition)
          description = <<-END
            Specifies when noncurrent object versions transitions (documented below).
            At least one of `expiration`, `transition`, `noncurrent_version_expiration`, `noncurrent_version_transition` must be specified.
          END

          attribute "days" {
            required    = true
            type        = number
            description = <<-END
              Specifies the number of days an object's noncurrent object versions expire.
            END
          }

          attribute "storage_class" {
            required    = true
            type        = string
            description = <<-END
              Specifies the Amazon S3 storage class to which you want the noncurrent versions object to transition.
              Can be `ONEZONE_IA`, `STANDARD_IA`, `INTELLIGENT_TIERING`, `GLACIER`, or `DEEP_ARCHIVE`.
            END
          }
        }
      }
    }

    section {
      title = "Extended Resource Configuration"

      section {
        title = "S3 Access Points"

        variable "access_points" {
          type        = list(access_point)
          default     = []
          description = <<-END
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
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name you want to assign to this access point.
            END
          }

          attribute "account_id" {
            type        = string
            description = <<-END
              The AWS account ID for the owner of the bucket for which you want to create an access point.
              Defaults to automatically determined account ID of the Terraform AWS provider.
            END
          }

          attribute "policy" {
            type        = string
            description = <<-END
              A valid JSON document that specifies the policy that you want to apply to this access point.
            END
          }

          attribute "vpc_id" {
            type        = string
            description = <<-END
              If set, this access point will only allow connections from the specified VPC ID.
            END
          }

          attribute "block_public_acls" {
            type        = bool
            default     = true
            description = <<-END
              Whether Amazon S3 should block public ACLs for this bucket.
              Enabling this setting does not affect existing policies or ACLs.
            END
          }

          attribute "block_public_policy" {
            type        = bool
            default     = true
            description = <<-END
              Whether Amazon S3 should block public bucket policies for this bucket.
              Enabling this setting does not affect the existing bucket policy.
              If `true`:
                - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.
            END
          }

          attribute "ignore_public_acls" {
            type        = bool
            default     = true
            description = <<-END
              Whether Amazon S3 should ignore public ACLs for this bucket.
              Enabling this setting does not affect the persistence of any existing ACLs and
              doesn't prevent new public ACLs from being set.
              If `true`:
                - Ignore public ACLs on this bucket and any objects that it contains.
            END
          }

          attribute "restrict_public_buckets" {
            type        = bool
            default     = true
            description = <<-END
              Whether Amazon S3 should restrict public bucket policies for this bucket.
              Enabling this setting does not affect the previously stored bucket policy,
              except that public and cross-account access within the public bucket policy,
              including non-public delegation to specific accounts, is blocked.
              If `true`:
                - Only the bucket owner and AWS Services can access this buckets if it has a public policy.
            END
          }
        }
      }

      section {
        title = "S3 bucket-level Public Access Block Configuration"

        variable "block_public_acls" {
          type        = bool
          default     = true
          description = <<-END
            Whether Amazon S3 should block public ACLs for this bucket.
            Enabling this setting does not affect existing policies or ACLs.
            If `true`:
              - `PUT Bucket acl` and `PUT Object acl` calls will fail if the specified ACL allows public access.
              - `PUT Object` calls will fail if the request includes an object ACL.
          END
        }

        variable "block_public_policy" {
          type        = bool
          default     = true
          description = <<-END
            Whether Amazon S3 should block public bucket policies for this bucket.
            Enabling this setting does not affect the existing bucket policy.
            If `true`:
              - Reject calls to `PUT Bucket policy` if the specified bucket policy allows public access.
          END
        }

        variable "ignore_public_acls" {
          type        = bool
          default     = true
          description = <<-END
            Whether Amazon S3 should ignore public ACLs for this bucket.
            Enabling this setting does not affect the persistence of any existing ACLs and
            doesn't prevent new public ACLs from being set.
            If `true`:
              - Ignore public ACLs on this bucket and any objects that it contains.
          END
        }

        variable "restrict_public_buckets" {
          type        = bool
          default     = true
          description = <<-END
            Whether Amazon S3 should restrict public bucket policies for this bucket.
            Enabling this setting does not affect the previously stored bucket policy,
            except that public and cross-account access within the public bucket policy,
            including non-public delegation to specific accounts, is blocked.
            If `true`:
              - Only the bucket owner and AWS Services can access this buckets if it has a public policy.
          END
        }
      }

      section {
        title = "Cross Account Access Configuration"

        variable "cross_account_identifiers" {
          type        = list(string)
          default     = []
          description = <<-END
            Specifies identifiers that should be granted cross account access to.
            If this list is empty Cross Account Access is not configured and all other
            options in this category are ignored.
          END
        }

        variable "cross_account_bucket_actions" {
          type        = list(string)
          default     = ["s3:ListBucket"]
          description = <<-END
            Specifies actions on the bucket to grant from cross account.
          END
        }

        variable "cross_account_object_actions" {
          type        = list(string)
          default     = ["s3:GetObject"]
          description = <<-END
            Specifies actions on bucket objects to grant from cross account.
          END
        }

        variable "cross_account_object_actions_with_forced_acl" {
          type        = list(string)
          default     = ["s3:PutObject", "s3:PutObjectAcl"]
          description = <<-END
            Specifies actions on bucket objects to grant only with foreced ACL from cross account.
          END
        }

        variable "cross_account_forced_acls" {
          type        = list(string)
          default     = ["bucket-owner-full-control"]
          description = <<-END
            Specifies ACLs to force on new objects for cross account access.
          END
        }
      }

      section {
        title = "Cloudfront Origin Access Identity Access"

        variable "create_origin_access_identity" {
          type        = bool
          default     = false
          description = <<-END
            Specifies whether to create and origin access identity and grant it access to read
            from the bucket. This can be used to grant a Cloudfront Distribution access to
            bucket objects when specifying this bucket as an origin.
            The Cloudfront Distribution must be in the same account.
            For cross account access create the OAI in the account of the cloudfront distribution and use
            `origin_acesss_identities` attribute to enable access.
            **Attention:** Objects shared that way need
            to be owned by the account the bucket belongs to and can not be owned by other accounts
            (e.g. when uploaded through cross-account-access).
          END
        }

        variable "origin_acesss_identities" {
          type        = list(string)
          default     = []
          description = <<-END
            Specify a list of Cloudfront OAIs to grant read-only access to.
            If in addition a new origin access identity is created via the `create_origin_access_identity`
            attribute, all identities will be granted access.
            **Attention:** Objects shared that way need
            to be owned by the account the bucket belongs to and can not be owned by other accounts
            (e.g. when uploaded through cross-account-access).
          END
        }
      }

      section {
        title = "ELB Log Delivery"

        variable "elb_log_delivery" {
          type        = bool
          description = <<-END
            Allow delivery of logs from Elastic Loadbalancers (ELB).
          END
        }

        variable "elb_regions" {
          type        = list(string)
          default     = []
          description = <<-END
            The names of the region whose AWS ELB account IDs are desired.
            Default is the region from the AWS provider configuration.
          END
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_tags" {
        type        = map(string)
        default     = {}
        description = <<-END
          A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
          overwritten by resource-specific tags.
        END
      }

      variable "module_depends_on" {
        type        = list(any)
        description = <<-END
          A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
        END
      }
    }

  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:
    END

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "bucket" {
      type        = object(bucket)
      description = <<-END
        All bucket attributes as returned by the `aws_s3_bucket` resource
        containing all arguments as specified above and the other attributes as
        specified below.
      END
    }

    output "id" {
      type        = string
      description = <<-END
        The name of the bucket.
      END
    }

    output "arn" {
      type        = string
      description = <<-END
        The ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`.
      END
    }

    output "bucket_domain_name" {
      type        = string
      description = <<-END
        The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`.
      END
    }

    output "bucket_regional_domain_name" {
      type        = string
      description = <<-END
        The bucket region-specific domain name. The bucket domain name including
        the region name, please refer here for format. Note: The AWS CloudFront
        allows specifying S3 region-specific endpoint when creating S3 origin,
        it will prevent redirect issues from CloudFront to S3 Origin URL.
      END
    }

    output "hosted_zone_id" {
      type        = string
      description = <<-END
        The Route 53 Hosted Zone ID for this bucket's region.
      END
    }

    output "region" {
      type        = string
      description = <<-END
        The AWS region this bucket resides in.
      END
    }

    output "bucket_policy" {
      type        = object(bucket_policy)
      description = <<-END
        All bucket policy object attributes as returned by the `s3_bucket_policy`
        resource.
      END
    }

    output "origin_access_identity" {
      type        = object(origin_access_identity)
      description = <<-END
        All cloudfront origin access identity object attributes as returned by
        the `aws_cloudfront_origin_access_identity` resource.
      END
    }

    output "access_point" {
      type        = list(access_point)
      description = <<-END
        A list of `aws_s3_access_point` objects keyed by the `name` attribute.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation S3"
      content = <<-END
        - Access Points: https://docs.aws.amazon.com/AmazonS3/latest/dev/access-points.html
        - Default Encryption: https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
        - Optimizing Performance: https://docs.aws.amazon.com/AmazonS3/latest/dev/optimizing-performance.html
        - Requester Pays Bucket: https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html
        - Security: https://docs.aws.amazon.com/AmazonS3/latest/dev/security.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_access_point
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-s3-bucket"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS S3-Bucket" {
    value = "https://aws.amazon.com/s3/"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "AWS IAM Policy Document Guide" {
    value = "https://learn.hashicorp.com/terraform/aws/iam-policy"
  }
  ref "Requester Pays Buckets developer guide" {
    value = "https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html"
  }
  ref "examples/secure-s3-bucket/main.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/examples/secure-s3-bucket/main.tf"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/examples"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-s3-bucket/blob/master/CONTRIBUTING.md"
  }
}
