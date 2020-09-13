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
output "bucket" {
  description = "The full bucket object."
  value       = try(aws_s3_bucket.bucket[0], null)
}

output "bucket_policy" {
  description = "The full bucket object."
  value       = try(aws_s3_bucket_policy.bucket[0], null)
}

output "origin_access_identity" {
  description = "The AWS Cloudfront Origin Access Identity object."
  value       = try(aws_cloudfront_origin_access_identity.oai[0], null)
}

output "access_point" {
  description = "A map of acccess points keyed by name."
  value       = try(aws_s3_access_point.ap, null)
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
