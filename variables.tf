variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "bucket_name" {
  description = "Terraform state bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Terraform lock table"
  type        = string
}

variable "github_org" {
  description = "GitHub Organization"
  type        = string
}

variable "repository_name" {
  description = "GitHub Repository"
  type        = string
}

variable "branches" {
  description = "Allowed branches"
  type        = list(string)

  default = [
    "main"
  ]
}

variable "runner_role_name" {
  description = "IAM Role name used by GitHub Actions"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}