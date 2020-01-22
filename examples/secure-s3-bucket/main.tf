# ---------------------------------------------------------------------------------------------------------------------
# Create two secure S3 Buckets inside the same AWS Account
# This template creates an Example S3 Bucket and another Log S3 Bucket.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example App S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-app-bucket" {
  source = "../.."

  region = var.aws_region

  versioning = true

  logging = {
    target_bucket = module.example-log-bucket.id
    target_prefix = "log/"
  }

  cors_rule = {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.mineiros.io"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "Just a S3 Bucket"
    Environment = "Testing"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example Log S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-log-bucket" {
  source = "../.."

  region = var.aws_region
  acl    = "log-delivery-write"

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

# ---------------------------------------------------------------------------------------------------------------------
# Do not create the bucket
# ---------------------------------------------------------------------------------------------------------------------
module "example-no-bucket" {
  source = "../.."
  create = false
}
