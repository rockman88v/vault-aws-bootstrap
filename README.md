# Vault AWS Bootstrap

> Bootstrap AWS infrastructure phục vụ cho việc quản lý cấu hình Vault bằng Terraform thông qua GitHub Actions (OIDC).

---

# Giới thiệu

Repository này có nhiệm vụ tạo toàn bộ các AWS Resource cần thiết để các repository Terraform khác (ví dụ `vault-config`) có thể chạy trên GitHub Actions Self-hosted Runner mà **không cần sử dụng AWS Access Key**.

Repository này chỉ cần triển khai **một lần duy nhất** cho mỗi AWS Account.

Sau khi hoàn thành, toàn bộ Terraform của các hệ thống khác sẽ:

* Lưu Terraform State lên Amazon S3
* Sử dụng DynamoDB để lock state
* Authenticate từ GitHub sang AWS bằng OpenID Connect (OIDC)
* Assume IAM Role để thao tác trên AWS
* Không cần lưu bất kỳ AWS Access Key nào trong GitHub Secrets

Kiến trúc tổng thể:

```
GitHub Actions
        │
        │ OIDC
        ▼
GitHub OIDC Provider (AWS)
        │
        ▼
IAM Role
        │
        ├──────────────► S3 Backend
        │
        └──────────────► DynamoDB Lock
```

---

# Repository Structure

```
.
├── docs/
│
├── modules/
│   ├── backend/
│   ├── github-oidc/
│   └── github-runner-role/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars.example
└── README.md
```

Repository được chia thành hai phần:

* **Terraform Modules**
* **Root Module**

---

# Modules

## 1. backend

Tạo Terraform Backend dùng chung cho toàn bộ hệ thống.

Bao gồm:

* Amazon S3 Bucket
* Versioning
* Server Side Encryption
* Public Access Block
* Ownership Control
* DynamoDB Lock Table

Sau này tất cả các repository Terraform sẽ sử dụng backend này.

---

## 2. github-oidc

Tạo GitHub OpenID Connect Provider trong AWS IAM.

Terraform Module này cho phép GitHub Actions có thể authenticate trực tiếp tới AWS thông qua OIDC.

Không cần:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Đây là Best Practice hiện nay của AWS.

---

## 3. github-runner-role

Tạo IAM Role dành cho GitHub Actions Runner.

Role này:

* Trust GitHub OIDC Provider
* Chỉ cho phép repository được chỉ định assume role
* Có quyền thao tác với Terraform Backend

Ví dụ:

* S3
* DynamoDB

Sau này có thể mở rộng thêm:

* KMS
* IAM
* Route53
* Secrets Manager

---

# Root Module

Root Module chỉ có nhiệm vụ gọi các module phía trên.

Ví dụ:

```
module "backend" {}

module "github_oidc" {}

module "github_runner_role" {}
```

Điều này giúp module có thể tái sử dụng ở nhiều project khác nhau.

---

# AWS Resources được tạo

Repository này sẽ tạo duy nhất một bộ resource cho toàn bộ AWS Account.

| Resource             | Mục đích                            |
| -------------------- | ----------------------------------- |
| S3 Bucket            | Terraform State Backend             |
| DynamoDB Table       | Terraform State Lock                |
| GitHub OIDC Provider | Authenticate GitHub với AWS         |
| IAM Role             | Role dành cho GitHub Actions Runner |
| IAM Policy           | Quyền truy cập S3 + DynamoDB        |

Toàn bộ các môi trường:

* dev
* uat
* prod

sẽ dùng chung backend này.

Terraform State sẽ được phân tách theo path trong S3.

Ví dụ:

```
vault-config/dev/terraform.tfstate

vault-config/uat/terraform.tfstate

vault-config/prod/terraform.tfstate
```

---

# Quy trình triển khai

## Bước 1

Clone repository

```
git clone <repo>

cd vault-aws-bootstrap
```

Lưu ý comment toàn bộ nội dung file `backend.tf`, chỉ un-comment sau khi đã apply để tạo xong resources.

---

## Bước 2

Cài đặt:

* Terraform
* AWS CLI

---

## Bước 3

Configure AWS CLI

```
aws configure
```

Kiểm tra

```
aws sts get-caller-identity
```

---

## Bước 4

Copy file cấu hình

```
cp terraform.tfvars.example terraform.tfvars
```

Chỉnh sửa các thông tin:

* AWS Region
* GitHub Repository Owner
* Repository Name
* Branch được phép assume role

---

## Bước 5

Khởi tạo Terraform

```
terraform init
```

---

## Bước 6

Kiểm tra

```
terraform validate

terraform fmt -recursive

terraform plan
```

---

## Bước 7

Apply

```
terraform apply
```

---

## Bước 8

Sau khi S3 Backend đã được tạo

Thêm file `backend.tf` có nội dung mẫu như bên dưới hoặc uncomment file đã comment ở bước 1

Ví dụ

```
terraform {

  backend "s3" {

    bucket         = "terraform-state"

    key            = "bootstrap/terraform.tfstate"

    region         = "ap-southeast-1"

    dynamodb_table = "terraform-lock"

    encrypt = true

  }

}
```

Sau đó migrate state

```
terraform init -reconfigure
```

Terraform sẽ tự động chuyển Local State lên S3.
```
sysadmin@master:~/vault-aws-bootstrap$ terraform init -reconfigure
Initializing modules...
Initializing provider plugins found in the configuration...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/tls from the dependency lock file
- Using previously-installed hashicorp/aws v6.53.0
- Using previously-installed hashicorp/tls v4.3.0

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins found in the state...
- Reusing previous version of hashicorp/aws
- Reusing previous version of hashicorp/tls
- Using previously-installed hashicorp/aws v6.53.0
- Using previously-installed hashicorp/tls v4.3.0


╷
│ Warning: Deprecated Parameter
│
│   on backend.tf line 6, in terraform:
│    6:     dynamodb_table = "terraform-lock"
│
│ The parameter "dynamodb_table" is deprecated. Use parameter "use_lockfile" instead.
╵
Terraform has been successfully initialized!

```

---

# Repository tiếp theo

Sau khi bootstrap hoàn thành, repository tiếp theo sẽ là:

```
vault-config-terraform
```

Repository này sẽ:

* Quản lý Vault Policy
* Quản lý Kubernetes Auth
* Quản lý OIDC Auth
* Quản lý Secret Engine
* Quản lý Role
* Quản lý Identity Group
* Quản lý toàn bộ cấu hình Vault bằng Terraform

Tất cả sẽ sử dụng IAM Role và Terraform Backend được tạo bởi repository này.

---

# Mục tiêu

Repository này giúp toàn bộ hệ thống đạt được các mục tiêu:

* Không sử dụng AWS Access Key
* Không lưu Secret trên GitHub
* Terraform State tập trung
* Có cơ chế Lock State
* Áp dụng Best Practice của AWS và Terraform
* Dễ mở rộng cho nhiều repository Terraform khác trong tương lai
