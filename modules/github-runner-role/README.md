# GitHub Runner Role

## Mục đích

Module này tạo IAM Role cho GitHub Actions.

Github runner sẽ được Assume IAM Role thông qua GitHub OIDC.

(Không sử dụng AWS Access Key)

---

## Luồng hoạt động

```text
GitHub Actions
      │
      │ JWT
      ▼
GitHub OIDC
      │
      ▼
AWS IAM OIDC Provider
      │
      ▼
IAM Role
      │
      ▼
S3 Backend
DynamoDB Lock
```

---

## Resource được tạo

- IAM Role
- IAM Policy
- Role Policy Attachment

---

## Quyền

### S3

- ListBucket
- GetObject
- PutObject
- DeleteObject

### DynamoDB

- DescribeTable
- GetItem
- PutItem
- DeleteItem
- UpdateItem

---

## Trust Policy

Role chỉ cho phép Assume từ:

- đúng GitHub Organization
- đúng Repository
- đúng Branch

Ví dụ

```
repo:rockman88v/vault-config-terraform:ref:refs/heads/main
```

---

## Ví dụ

```hcl
module "runner_role" {

  source = "./modules/github-runner-role"

  role_name = "vault-config-runner"

  github_org = "vietdevops"

  repository_name = "vault-config"

  branches = [
    "main"
  ]

  oidc_provider_arn = module.github_oidc.provider_arn

  bucket_name = module.backend.bucket_name

  bucket_arn = module.backend.bucket_arn

  dynamodb_table_name = module.backend.dynamodb_table_name

  dynamodb_table_arn = module.backend.dynamodb_table_arn

}
```

---

## Output

| Output | Description |
|----------|------------|
| role_arn | IAM Role ARN |
| role_name | IAM Role Name |
| policy_arn | IAM Policy ARN |
