data "aws_iam_policy_document" "assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

    condition {

      test = "StringLike"

      variable = "token.actions.githubusercontent.com:sub"

      values = local.github_subjects

    }

  }

}

resource "aws_iam_role" "github_runner" {

  name = var.role_name

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      Name = var.role_name
    },
    var.tags
  )

}