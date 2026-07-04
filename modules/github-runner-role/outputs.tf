output "role_arn" {

  value = aws_iam_role.github_runner.arn

}

output "role_name" {

  value = aws_iam_role.github_runner.name

}

output "policy_arn" {

  value = aws_iam_policy.terraform.arn

}