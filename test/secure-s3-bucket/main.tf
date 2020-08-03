# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO SECURE S3 BUCKETS INSIDE THE SAME AWS ACCOUNT
# This template creates an Example S3 Bucket and another Log S3 Bucket.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example App S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-app-bucket" {
  source = "../.."

  versioning = true

  logging = {
    target_bucket = module.example-log-bucket.id
    target_prefix = "log/"
  }

  create_origin_access_identity = true

  access_points = [
    {
      name = "app"
    }
  ]

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

  acl = "log-delivery-write"

  # this is just for running the example even if logs already exist
  # this should not be set in production as all objects will be unrecoverably destroyed
  force_destroy = true

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
# Create the Example ELB Log S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------
module "example-elb-log-bucket" {
  source = "../.."

  elb_regions = ["us-east-1", "eu-west-1"]
}

# ---------------------------------------------------------------------------------------------------------------------
# Do not create the bucket
# ---------------------------------------------------------------------------------------------------------------------
module "example-no-bucket" {
  source = "../.."

  module_enabled = false
}
