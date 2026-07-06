module "backend" {
  source = "./modules/backend"
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  tags = var.tags
}

module "github_oidc" {
  source = "./modules/github-oidc"
  tags = var.tags
}

module "github_runner_role" {
  source = "./modules/github-runner-role"
  role_name = var.runner_role_name
  github_org = var.github_org
  repository_name = var.repository_name
  branches = var.branches
  oidc_provider_arn = module.github_oidc.provider_arn
  bucket_name = module.backend.bucket_name
  bucket_arn  = module.backend.bucket_arn
  dynamodb_table_name = module.backend.dynamodb_table_name
  dynamodb_table_arn  = module.backend.dynamodb_table_arn
  tags = var.tags
}