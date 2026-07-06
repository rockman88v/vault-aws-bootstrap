output "terraform_state_bucket" {
  value = module.backend.bucket_name
}

output "terraform_lock_table" {
  value = module.backend.dynamodb_table_name
}

output "github_oidc_provider_arn" {
  value = module.github_oidc.provider_arn
}

output "github_runner_role_name" {
  value = module.github_runner_role.role_name
}

output "github_runner_role_arn" {
  value = module.github_runner_role.role_arn
}

output "github_runner_policy_arn" {
  value = module.github_runner_role.policy_arn
}