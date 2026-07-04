# Backend Module

## Mục đích

Module này tạo toàn bộ backend phục vụ Terraform.

Bao gồm:

- S3 Bucket lưu Terraform State
- DynamoDB Table dùng để State Lock

---

## Kiến trúc

```
Terraform
      │
      ▼
 S3 Bucket
      │
Terraform State
      │
      ▼
DynamoDB
      │
 State Lock
```

---

## Tính năng

- S3 Versioning
- Server Side Encryption
- Public Access Block
- Bucket Owner Enforced
- DynamoDB On-Demand
- Point In Time Recovery

---

## Ví dụ

```hcl
module "backend" {

  source = "./modules/backend"

  bucket_name = "vietdevops-tfstate"

  dynamodb_table_name = "terraform-lock"

  tags = {
    Project = "Vault"
  }

}
```

---

## Outputs

| Output | Description |
|---------|-------------|
| bucket_name | S3 Bucket Name |
| bucket_arn | S3 Bucket ARN |
| dynamodb_table_name | DynamoDB Table |
| dynamodb_table_arn | DynamoDB ARN |