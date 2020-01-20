# ---------------------------------------------------------------------------------------------------------------------
# Create two secure S3 Buckets inside the same AWS Account
# This template creates an Example S3 Bucket and another Log S3 Bucket.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example App S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-bucket" {
  source = "../.."

  acl = "log-delivery-write"

  versioning = {
    enabled = true
  }

  logging = {
    target_bucket = module.log-bucket.id
    target_prefix = "log/"
  }

  cors_rule = {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.mineiros.io"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  policy = <<-POLICY
    "Statement": [
      {
        "Sid": "IPAllow",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": "arn:aws:s3:::examplebucket/*",
        "Condition": {
           "NotIpAddress": {"aws:SourceIp": "54.240.143.0/24"}
        }
      }
    ]
  POLICY

  tags = {
    Name        = "Just a S3 Bucket"
    Environment = "Testing"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example Log S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "log-bucket" {
  source = "../.."

  lifecycle_rules = [
    {
      id      = "log"
      enabled = true

      prefix = "log/"

      tags = {
        "rule"      = "log"
        "autoclean" = "true"
      }

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA" # or "ONEZONE_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = 90
      }
    }
  ]
}
