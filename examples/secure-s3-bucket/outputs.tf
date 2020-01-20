output "example-s3-bucket-arn" {
  description = "The ARN of our example bucket."
  value       = module.example-app-bucket.arn
}

output "example-s3-log-bucket-arn" {
  description = "The ARN of our example log bucket."
  value       = module.example-log-bucket
}
