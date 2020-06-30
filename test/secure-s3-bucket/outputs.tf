output "example-app-bucket" {
  description = "The outputs of our example app bucket."
  value       = module.example-app-bucket
}

output "example-log-bucket" {
  description = "The outputs of our example log bucket."
  value       = module.example-log-bucket
}

output "example-elb-log-bucket" {
  description = "The outputs of our example elb log bucket."
  value       = module.example-elb-log-bucket
}

output "example-no-bucket" {
  description = "The outputs of our example no bucket."
  value       = module.example-no-bucket
}
