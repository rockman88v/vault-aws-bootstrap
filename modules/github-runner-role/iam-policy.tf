data "aws_iam_policy_document" "terraform" {
  statement {
    sid = "TerraformStateBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      var.bucket_arn
    ]
  }
  statement {
    sid = "TerraformStateObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.bucket_arn}/*"
    ]
  }
  statement {
    sid = "TerraformLock"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      var.dynamodb_table_arn
    ]
  }
}

resource "aws_iam_policy" "terraform" {
  name   = "${var.role_name}-policy"
  policy = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.github_runner.name
  policy_arn = aws_iam_policy.terraform.arn
}