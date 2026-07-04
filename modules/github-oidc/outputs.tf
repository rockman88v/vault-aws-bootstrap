output "provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "provider_url" {
  value = aws_iam_openid_connect_provider.github.url
}

output "provider_client_ids" {
  value = aws_iam_openid_connect_provider.github.client_id_list
}