variable "role_name" {
  description = "IAM Role name"
  type        = string
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "branches" {
  description = "Allowed branches"
  type        = list(string)

  default = [
    "main"
  ]
}

variable "oidc_provider_arn" {
  description = "GitHub OIDC Provider ARN"
  type        = string
}

variable "bucket_arn" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}