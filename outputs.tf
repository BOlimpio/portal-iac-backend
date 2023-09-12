output "get_module_repositories_url" {
  value = aws_lambda_function_url.get_module_repositories_url.function_url
}

output "download_how_to_use_files_url" {
  value = aws_lambda_function_url.download_how_to_use_files_ul.function_url
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.portal_iac_s3_distribution.domain_name
}
