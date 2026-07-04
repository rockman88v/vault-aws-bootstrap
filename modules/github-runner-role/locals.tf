locals {

  github_subjects = [

    for branch in var.branches :

    "repo:${var.github_org}/${var.repository_name}:ref:refs/heads/${branch}"

  ]

}