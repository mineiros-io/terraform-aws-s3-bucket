provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

module "s3-bucket" {
  source = "../.."

  create = true
  bucket = "mineiros-test-bucket"
  acl    = "private"
}
