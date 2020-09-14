# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket" {
  description = "The name of the bucket. (forces new resource, default: unique random name)"
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. (forces new resource)"
  type        = string
  default     = null
}

variable "acl" {
  description = "The canned ACL to apply. https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl"
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

  # Example:
  #
  # tags = {
  #   Name        = "Just an Example"
  #   Environment = "Testing"
  # }
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

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. See Requester Pays Buckets developer guide for more information."
  type        = string
  default     = "BucketOwner"
}

variable "cors_rule" {
  description = "Object containing a rule of Cross-Origin Resource Sharing."
  type        = any
  default     = {}

  # Example:
  #
  # cors_rule = {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.example.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}

variable "versioning" {
  description = "Boolean specifying enabled state of versioning or object containing detailed versioning configuration."
  type        = any
  default     = false

  # Examples:
  #
  # versioning = true
  # versioning = {
  #   enabled    = true
  #   mfa_delete = true
  # }
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}

  # Example:
  #
  # logging = {
  #   target_bucket = "example-bucket"
  #   target_prefix = "log/"
  # }
}

variable "apply_server_side_encryption_by_default" {
  description = "Map containing server-side encryption configuration."
  type        = map(string)
  default = {
    sse_algorithm = "AES256"
  }
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []

  # Example:
  #
  # lifecycle_rules = [
  #   {
  #     id      = "log"
  #     enabled = true
  #
  #     prefix = "log/"
  #
  #     tags = {
  #       "rule"      = "log"
  #       "autoclean" = "true"
  #     }
  #
  #     transition = [
  #       {
  #         days          = 30
  #         storage_class = "STANDARD_IA" # or "ONEZONE_IA"
  #       },
  #       {
  #         days          = 60
  #         storage_class = "GLACIER"
  #       }
  #     ]
  #
  #     expiration = {
  #       days = 90
  #     }
  #   }
  # ]
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
  description = "Identifiers that you want to grant cross account access to."
  default     = []

  # Example:
  #
  # cross_account_identifiers = [
  #   "112233445566",
  #   "112233445566"
  # ]
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

variable "create_origin_access_identity" {
  type        = bool
  description = "Whether to create an origin access identity (OAI) and policy to be accessible from Cloudfront."
  default     = false
}

variable "origin_access_identities" {
  type        = list(string)
  description = "Cloudfront Origin Access Identities to grant read-only access to."
  default     = []
}

variable "elb_log_delivery" {
  type        = bool
  description = "Whether to allow log delivery from ELBs."
  default     = null
}

variable "elb_regions" {
  type        = list(string)
  description = "The names of the region whose AWS ELB account IDs are desired."
  default     = []
}

variable "access_points" {
  type        = any
  description = "A List of Access Point configurations."
  default     = []
}

# ------------------------------------------------------------------------------
# OPTIONAL MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_tags" {
  type        = map(string)
  description = "(Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be overwritten by resource-specific tags."
  default     = {}
}

variable "module_depends_on" {
  type        = any
  description = "(optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
