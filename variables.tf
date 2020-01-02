variable "bucket" {
  description = "The name of the bucket. (forces new resource, default: unique random name)"
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix. (forces new resource)"
  type        = string
  default     = null
}

variable "create" {
  description = "Whether the bucket should be created."
  type        = bool
  default     = true
}

variable "acl" {
  description = "The canned ACL to apply."
  type        = string
  default     = "private"
}

variable "policy" {
  description = "A bucket policy in JSON format."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "acceleration_status" {
  description = "Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null
}

variable "region" {
  description = "If specified, the AWS region this bucket should reside in. (default: region of the callee)"
  type        = string
  default     = null
}

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. See Requester Pays Buckets developer guide for more information."
  type        = string
  default     = "BucketOwner"
}

variable "cors_rule" {
  description = "Object containing a rule of Cross-Origin Resource Sharing."
  type        = any
  default     = {}
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}

variable "apply_server_side_encryption_by_default" {
  description = "Map containing server-side encryption configuration."
  type        = map(any)
  default = {
    sse_algorithm = "AES256"
  }
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
}

variable "cross_account_identifiers" {
  type        = list(string)
  description = "Identifiers that you want to grant cross account access to"
  default     = []
}

variable "cross_account_bucket_actions" {
  type        = list(string)
  description = "Actions on the bucket to allow"
  default = [
    "s3:ListBucket"
  ]
}

variable "cross_account_object_actions" {
  type        = list(string)
  description = "Actions on bucket objects to allow"
  default = [
    "s3:GetObject"
  ]
}

variable "cross_account_object_actions_with_forced_acl" {
  type        = list(string)
  description = "Actions on bucket objects to allow only with forced acl"
  default = [
    "s3:PutObject",
    "s3:PutObjectAcl"
  ]
}

variable "cross_account_forced_acls" {
  type        = list(string)
  description = "ACLs to force on new objects for cross account xs"
  default = [
    "bucket-owner-full-control"
  ]
}
