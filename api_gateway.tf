resource "aws_api_gateway_rest_api" "portal_iac" {
  name        = "PortalIACAPI"
  description = "API for Portal IAC"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  parent_id   = aws_api_gateway_rest_api.portal_iac.root_resource_id
  path_part   = "v1"
}

##################################### API GATEWAY RESOURCES 

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

##################################### API GATEWAY METHODS 

resource "aws_api_gateway_method" "api_methods_get_module_data_conf" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_get_module_data_conf" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_download_how_to_use" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_download_how_to_use" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_get_portal_data" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_get_portal_data" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_count_contrib_blogs" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_count_contrib_blogs" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_methods_get_number_of_modules" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_get_number_of_modules" {
  rest_api_id   = aws_api_gateway_rest_api.portal_iac.id
  resource_id   = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

##################################### API GATEWAY INTEGRATIONS 

resource "aws_api_gateway_integration" "api_integrations_get_module_data_conf" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method             = aws_api_gateway_method.api_methods_get_module_data_conf.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_module_data_conf.invoke_arn
}

resource "aws_api_gateway_integration" "api_integrations_options_get_module_data_conf" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method             = aws_api_gateway_method.options_get_module_data_conf.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
}

resource "aws_api_gateway_integration" "api_integrations_download_how_to_use" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method             = aws_api_gateway_method.api_methods_download_how_to_use.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.download_how_to_use.invoke_arn

  request_templates = {
    "application/json" = jsonencode({
      "queryStringParameters" : {
        "repo_name" : "$input.params('repo_name')"
      }
    })
  }
}

resource "aws_api_gateway_integration" "api_integrations_options_download_how_to_use" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method             = aws_api_gateway_method.options_download_how_to_use.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
}


resource "aws_api_gateway_integration" "api_integrations_get_portal_data" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method             = aws_api_gateway_method.api_methods_get_portal_data.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_portal_data.invoke_arn

  request_templates = {
    "application/json" = jsonencode({
      "queryStringParameters" : {
        "folder_name" : "$input.params('folder_name')"
      }
    })
  }
}

resource "aws_api_gateway_integration" "api_integrations_options_get_portal_data" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method             = aws_api_gateway_method.options_get_portal_data.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
}

resource "aws_api_gateway_integration" "api_integrations_count_contrib_blogs" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method             = aws_api_gateway_method.api_methods_count_contrib_blogs.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.count_contrib_blogs.invoke_arn
}

resource "aws_api_gateway_integration" "api_integrations_options_count_contrib_blogs" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method             = aws_api_gateway_method.options_count_contrib_blogs.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
}


resource "aws_api_gateway_integration" "api_integrations_get_number_of_modules" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method             = aws_api_gateway_method.api_methods_get_number_of_modules.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_number_of_modules.invoke_arn
}

resource "aws_api_gateway_integration" "api_integrations_options_get_number_of_modules" {
  rest_api_id             = aws_api_gateway_rest_api.portal_iac.id
  resource_id             = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method             = aws_api_gateway_method.options_get_number_of_modules.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
}


##################################### API GATEWAY METHOD RESPONSE
resource "aws_api_gateway_method_response" "api_method_response_get_module_data_conf" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method = aws_api_gateway_method.api_methods_get_module_data_conf.http_method
  status_code = "200"

  # Configuração da resposta do método
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_options_get_module_data_conf" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method = aws_api_gateway_method.options_get_module_data_conf.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method_response" "api_method_response_download_how_to_use" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method = aws_api_gateway_method.api_methods_download_how_to_use.http_method
  status_code = "200"

  # Configuração da resposta do método
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_options_download_how_to_use" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method = aws_api_gateway_method.options_download_how_to_use.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method_response" "api_method_response_get_portal_data" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method = aws_api_gateway_method.api_methods_get_portal_data.http_method
  status_code = "200"

  # Configuração da resposta do método
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_options_get_portal_data" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method = aws_api_gateway_method.options_get_portal_data.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method_response" "api_method_response_count_contrib_blogs" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method = aws_api_gateway_method.api_methods_count_contrib_blogs.http_method
  status_code = "200"

  # Configuração da resposta do método
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_options_count_contrib_blogs" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method = aws_api_gateway_method.options_count_contrib_blogs.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method_response" "api_method_response_get_number_of_modules" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method = aws_api_gateway_method.api_methods_get_number_of_modules.http_method
  status_code = "200"


  # Configuração da resposta do método
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_options_get_number_of_modules" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method = aws_api_gateway_method.options_get_number_of_modules.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

##################################### API INTEGRATION RESPONSE
resource "aws_api_gateway_integration_response" "api_integration_response_get_module_data_conf" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method = aws_api_gateway_method.api_methods_get_module_data_conf.http_method
  status_code = aws_api_gateway_method_response.api_method_response_get_module_data_conf.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_get_module_data_conf ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_options_get_module_data_conf" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_module_data_conf.id
  http_method = aws_api_gateway_method.options_get_module_data_conf.http_method
  status_code = aws_api_gateway_method_response.method_response_options_get_module_data_conf.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_options_get_module_data_conf ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_download_how_to_use" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method = aws_api_gateway_method.api_methods_download_how_to_use.http_method
  status_code = aws_api_gateway_method_response.api_method_response_download_how_to_use.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_download_how_to_use ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_options_download_how_to_use" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_download_how_to_use.id
  http_method = aws_api_gateway_method.options_download_how_to_use.http_method
  status_code = aws_api_gateway_method_response.method_response_options_download_how_to_use.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_options_download_how_to_use ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_get_portal_data" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method = aws_api_gateway_method.api_methods_get_portal_data.http_method
  status_code = aws_api_gateway_method_response.api_method_response_get_portal_data.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_get_portal_data ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_options_get_portal_data" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_portal_data.id
  http_method = aws_api_gateway_method.options_get_portal_data.http_method
  status_code = aws_api_gateway_method_response.method_response_options_get_portal_data.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_options_get_portal_data ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_count_contrib_blogs" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method = aws_api_gateway_method.api_methods_count_contrib_blogs.http_method
  status_code = aws_api_gateway_method_response.api_method_response_count_contrib_blogs.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_count_contrib_blogs ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_options_count_contrib_blogs" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_count_contrib_blogs.id
  http_method = aws_api_gateway_method.options_count_contrib_blogs.http_method
  status_code = aws_api_gateway_method_response.method_response_options_count_contrib_blogs.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_options_count_contrib_blogs ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_get_number_of_modules" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method = aws_api_gateway_method.api_methods_get_number_of_modules.http_method
  status_code = aws_api_gateway_method_response.api_method_response_get_number_of_modules.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_get_number_of_modules ]

}

resource "aws_api_gateway_integration_response" "api_integration_response_options_get_number_of_modules" {
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  resource_id = aws_api_gateway_resource.api_resource_get_number_of_modules.id
  http_method = aws_api_gateway_method.options_get_number_of_modules.http_method
  status_code = aws_api_gateway_method_response.method_response_options_get_number_of_modules.status_code

  #content_handling = "CONVERT_TO_TEXT" # Configuração para Content Handling

  # Configuração da Integração Response


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.api_integrations_options_get_number_of_modules ]

}

##################################### API GATEWAY DEPLOYMENT

resource "aws_api_gateway_deployment" "portal_iac" {
  depends_on = [
    aws_api_gateway_integration.api_integrations_get_module_data_conf,
    aws_api_gateway_integration.api_integrations_download_how_to_use,
    aws_api_gateway_integration.api_integrations_get_portal_data,
    aws_api_gateway_integration.api_integrations_count_contrib_blogs,
    aws_api_gateway_integration.api_integrations_get_number_of_modules,
  ]
  rest_api_id = aws_api_gateway_rest_api.portal_iac.id
  stage_name  = "api"
}


