variable "bucket_name" {
  description = "Terraform state bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Terraform lock table name"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if not empty"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable bucket versioning"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Optional KMS Key ARN for S3 encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}