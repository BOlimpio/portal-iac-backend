# AWS Lambda filename.method_name as handler format.

resource "aws_lambda_function" "get_module_data_conf" {
  description = "Function that will get the information of all modules that start with prefix 'm-portal-' and have the file 'module-data.conf'"
  function_name = "portal_iac_get_module_data_conf"
  handler       = "get_module_data_conf.get_module_data_conf"  # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.7"                        # Set the Python version you are using
  s3_bucket     = aws_s3_bucket.lambda_code_github.bucket
  s3_key        = "get_module_data_conf.zip"
  role          = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.github_lambda_layer.arn]

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.upload_get_module_conf_object ]
}

resource "aws_lambda_function" "download_how_to_use" {
  description   = "Function that receives the name of the repository as a parameter and downloads the files in the 'how-to-use' folder"
  function_name = "portal_iac_download_how_to_use"
  handler       = "download_how_to_use.download_how_to_use"        # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.7"                                # Set the Python version you are using
  s3_bucket     = aws_s3_bucket.lambda_code_github.bucket
  s3_key        = "download_how_to_use.zip"  
  role          = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.github_lambda_layer.arn]

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.upload_download_how_to_use_object ]
}

resource "aws_lambda_function" "get_portal_data" {
  description   = "Function that receives the folder name of the content as a parameter and retrive information about blogs post or contributors"
  function_name = "portal_iac_get_portal_data"
  handler       = "get_portal_data.get_data_from_folder"        # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.7"                                # Set the Python version you are using
  s3_bucket     = aws_s3_bucket.lambda_code_github.bucket
  s3_key        = "get_portal_data.zip"  
  role          = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.github_lambda_layer.arn]

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.upload_get_portal_data_object ]
}

resource "aws_lambda_function" "count_contrib_blogs" {
  description   = "Get the number of contributors and blogs post"
  function_name = "portal_iac_count_contrib_blogs"
  handler       = "count_contrib_blogs.count_files_in_folder"        # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.7"                                # Set the Python version you are using
  s3_bucket     = aws_s3_bucket.lambda_code_github.bucket
  s3_key        = "count_contrib_blogs.zip"  
  role          = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.github_lambda_layer.arn]

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.count_contrib_blogs_object ]
}

resource "aws_lambda_function" "get_number_of_modules" {
  description   = "Get the number of contributors and blogs post"
  function_name = "portal_iac_get_number_of_modules"
  handler       = "get_number_of_modules.get_number_of_modules"        # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.7"                                # Set the Python version you are using
  s3_bucket     = aws_s3_bucket.lambda_code_github.bucket
  s3_key        = "get_number_of_modules.zip"  
  role          = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.github_lambda_layer.arn]

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.get_number_of_modules_object ]
}

resource "aws_lambda_layer_version" "github_lambda_layer" {
  filename = aws_s3_object.upload_lambda_layer_object.source
  layer_name = "lambda_layer"
  compatible_runtimes = ["python3.7"]
}


########### Lambda Permission ###########

resource "aws_lambda_permission" "api_gtw_permission_get_module_data_conf" {
  statement_id  = "AllowAPIGatewayInvoke_get_module_data_conf"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_module_data_conf.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portal_iac.execution_arn}/*"
}

resource "aws_lambda_permission" "api_gtw_permission_download_how_to_use" {
  statement_id  = "AllowAPIGatewayInvoke_download_how_to_use"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.download_how_to_use.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portal_iac.execution_arn}/*"
}

resource "aws_lambda_permission" "api_gtw_permission_get_portal_data" {
  statement_id  = "AllowAPIGatewayInvoke_get_portal_data"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_portal_data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portal_iac.execution_arn}/*"
}

resource "aws_lambda_permission" "api_gtw_permission_count_contrib_blogs" {
  statement_id  = "AllowAPIGatewayInvoke_count_contrib_blogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.count_contrib_blogs.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portal_iac.execution_arn}/*"
}

resource "aws_lambda_permission" "api_gtw_permission_get_number_of_modules" {
  statement_id  = "AllowAPIGatewayInvoke_get_number_of_modules"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_number_of_modules.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portal_iac.execution_arn}/*"
}