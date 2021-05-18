# ---------------------------------------------------------------------------------------------------------------------
# CREATE TWO SECURE S3 BUCKETS INSIDE THE SAME AWS ACCOUNT
# This example creates a S3 Bucket and another Log S3 Bucket.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example App S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-app-bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.5.0"

  bucket_prefix = "app"

  access_points = [{ name = "app" }]

  versioning = true

  logging = {
    target_bucket = module.example-log-bucket.id
    target_prefix = "log/app/"
  }

  tags = {
    Name = "SPA S3 Bucket"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Example Log S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "example-log-bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.5.0"

  bucket_prefix = "log"

  acl = "log-delivery-write"

  # allow elb log delivery from multiple regions
  elb_regions = ["us-east-1", "eu-west-1"]

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
          storage_class = "STANDARD_IA"
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
