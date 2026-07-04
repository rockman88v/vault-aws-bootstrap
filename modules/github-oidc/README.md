# GitHub OIDC Module

## Mục đích

Module này tạo GitHub OpenID Connect Provider trong AWS IAM.

Sau khi được tạo, GitHub Actions có thể xác thực trực tiếp với AWS mà **không cần Access Key hoặc Secret Key**.

---

## Kiến trúc

```text
GitHub Actions
        │
        │ JWT Token
        ▼
GitHub OIDC
        │
        ▼
AWS IAM OIDC Provider
        │
        ▼
STS AssumeRoleWithWebIdentity
```

---

## Resource được tạo

- IAM OpenID Connect Provider

---

## Provider URL

```
https://token.actions.githubusercontent.com
```

---

## Client ID

```
sts.amazonaws.com
```

---

## Thumbprint

Terraform sẽ tự động lấy thumbprint mới nhất từ GitHub thông qua provider `tls`.

Không cần hardcode.

---

## Ví dụ

```hcl
module "github_oidc" {

  source = "./modules/github-oidc"

}
```

---

## Output

| Name | Description |
|------|-------------|
| provider_arn | ARN của GitHub OIDC Provider |
