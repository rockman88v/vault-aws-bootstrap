terraform {
  backend "s3" {
    bucket         = "vietdevops-terraform-state-818600128395"
    key            = "vault-aws-bootstrap/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}