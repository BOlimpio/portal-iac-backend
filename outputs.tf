output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.portal_iac_s3_distribution.domain_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.portal_iac.invoke_url
}