resource "aws_api_gateway_rest_api" "portal_iac" {
  name        = "PortalIACAPI"
  description = "API for Portal IAC"
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_rest_api.portal_iac.root_resource_id
  path_part   = "v1"
}

//API GATEWAY RESOURCES 

resource "aws_api_gateway_resource" "api_resource_get_module_data_conf" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "get_module_data_conf"
}

resource "aws_api_gateway_resource" "api_resource_download_how_to_use" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "download_how_to_use"
}

resource "aws_api_gateway_resource" "api_resource_get_portal_data" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "get_portal_data"
}

resource "aws_api_gateway_resource" "api_resource_count_contrib_blogs" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "count_contrib_blogs"
}

resource "aws_api_gateway_resource" "api_resource_get_number_of_modules" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "get_number_of_modules"
}

//API GATEWAY METHODS 

resource "aws_api_gateway_method" "api_methods_get_module_data_conf" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_download_how_to_use" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_get_portal_data" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_count_contrib_blogs" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_get_number_of_modules" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method   = "GET"
  authorization = "NONE"
}

//API GATEWAY INTEGRATIONS 

resource "aws_api_gateway_integration" "api_integrations_get_module_data_conf" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method             = aws_api_gateway_method.api_methods_get_module_data_conf.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_module_data_conf.invoke_arn
}

resource "aws_api_gateway_integration" "api_integrations_download_how_to_use" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method             = aws_api_gateway_method.api_methods_download_how_to_use.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.download_how_to_use.invoke_arn
}


resource "aws_api_gateway_integration" "api_integrations_get_portal_data" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method             = aws_api_gateway_method.api_methods_get_portal_data.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_portal_data.invoke_arn
}


resource "aws_api_gateway_integration" "api_integrations_count_contrib_blogs" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method             = aws_api_gateway_method.api_methods_count_contrib_blogs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.count_contrib_blogs.invoke_arn
}


resource "aws_api_gateway_integration" "api_integrations_get_number_of_modules" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method             = aws_api_gateway_method.api_methods_get_number_of_modules.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_number_of_modules.invoke_arn
}


//API GATEWAY DEPLOYMENT

resource "aws_api_gateway_deployment" "portal_iac" {
  depends_on = [
    aws_api_gateway_integration.api_integrations_get_module_data_conf,
    aws_api_gateway_integration.api_integrations_download_how_to_use,
    aws_api_gateway_integration.api_integrations_get_portal_data,
    aws_api_gateway_integration.api_integrations_count_contrib_blogs,
    aws_api_gateway_integration.api_integrations_get_number_of_modules,
  ]
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  stage_name  = "prod"
}


