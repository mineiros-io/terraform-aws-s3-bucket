# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------
output "id" {
  description = "The name of the bucket."
  value       = join("", aws_s3_bucket.bucket.*.id)
}

output "arn" {
  description = "The ARN of the bucket."
  value       = join("", aws_s3_bucket.bucket.*.arn)
}

output "bucket_domain_name" {
  description = "The domain name of the bucket."
  value       = join("", aws_s3_bucket.bucket.*.bucket_domain_name)
}

output "bucket_regional_domain_name" {
  description = "The region-specific domain name of the bucket."
  value       = join("", aws_s3_bucket.bucket.*.bucket_regional_domain_name)
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = join("", aws_s3_bucket.bucket.*.hosted_zone_id)
}

output "region" {
  description = "The AWS region this bucket resides in."
  value       = join("", aws_s3_bucket.bucket.*.region)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

locals {

  # fix tf13 / aws3 output change detection issues (no github issue)
  # terraform detects whitespace only changes in jsonencode() and claims
  # changes
  o_bucket_policy_policy = try(aws_s3_bucket_policy.bucket[0].policy, "{}")
  o_bucket_policy = try(merge(aws_s3_bucket_policy.bucket[0], {
    policy = jsonencode(jsondecode(local.o_bucket_policy_policy))
  }), null)
  # o_bucket_policy = try(aws_s3_bucket_policy.bucket[0], null)

  # fix tf13 / aws3 output change detection issues (no github issue)
  # bucket always detects change in tags out put from null => {}
  o_bucket_tags = try(aws_s3_bucket.bucket[0].tags, "{}")
  o_bucket = try(merge(aws_s3_bucket.bucket[0], {
    tags = local.o_bucket_tags != null ? local.o_bucket_tags : {}
  }), null)
}

output "bucket" {
  description = "The full bucket object."
  value       = local.o_bucket
}

output "bucket_policy" {
  description = "The full bucket object."
  value       = local.o_bucket_policy
}

output "origin_access_identity" {
  description = "The AWS Cloudfront Origin Access Identity object."
  value       = try(aws_cloudfront_origin_access_identity.oai[0], {})
}

output "access_point" {
  description = "A map of acccess points keyed by name."
  value       = aws_s3_access_point.ap
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES AS-IS
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled"
  value       = var.module_enabled
}
