output "example-s3-bucket" {
  description = "The outputs ARN of our example bucket."
  value       = module.example-app-bucket
}

output "example-s3-log-bucket" {
  description = "The outputs of our example log bucket."
  value       = module.example-log-bucket
}
