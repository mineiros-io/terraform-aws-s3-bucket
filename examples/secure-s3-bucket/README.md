[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# What this example shows

This code example creates two secure AWS S3-Buckets using the `mineiros-io/terraform-aws-s3-bucket` module.

One bucket is the `app` bucket which could be used to store a single-page-applications static files.

The other bucket is a `log` bucket to store access logs from the app bucket and additional logs from
ELBs in two different regions. Lifecycle rules are set up on the log bucket to migrate older logs into
cheaper storage.

## Basic usage
The code in [main.tf] defines...
```hcl
module "example-app-bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.6.0"

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

module "example-log-bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.6.0"

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
```

## Running the example

### Cloning the repository
```
git clone https://github.com/mineiros-io/terraform-module-template.git
cd terraform-module-template/examples/example
```

### Initializing Terraform
Run `terraform init` to initialize the example. The output should look like:

### Applying the example
Run `terraform apply -auto-approve` to create the resources.

### Destroying the example
Run `terraform destroy -refresh=false -auto-approve` to destroy all resources again.

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-s3-bucket

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-s3-bucket.svg?label=latest&sort=semver

[releases-github]: https://github.com/mineiros-io/terraform-aws-s3-bucket/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
