# AWS Lambda filename.method_name as handler format.

resource "aws_lambda_function" "get_module_repositories" {
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
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
    }
  }

  depends_on = [ aws_s3_object.upload_get_module_conf_object ]
}

resource "aws_lambda_function" "download_how_to_use_files" {
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
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
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
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
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
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
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
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
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

resource "aws_lambda_permission" "allow_cloudfront_get_module_repositories" {
  statement_id  = "AllowExecutionFromCloudFrontToLambdaGet_module_repositories"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_module_repositories.function_name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.portal_iac_s3_distribution.arn 
}

resource "aws_lambda_permission" "allow_cloudfront_download_how_to_use_files" {
  statement_id  = "AllowExecutionFromCloudFrontToLambda_download_how_to_use_files"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.download_how_to_use_files.function_name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.portal_iac_s3_distribution.arn 
}

resource "aws_lambda_permission" "allow_cloudfront_get_portal_data" {
  statement_id  = "AllowExecutionFromCloudFrontToLambda_get_portal_data"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_portal_data.function_name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.portal_iac_s3_distribution.arn 
}

resource "aws_lambda_permission" "allow_cloudfront_count_contrib_blogs" {
  statement_id  = "AllowExecutionFromCloudFrontToLambda_count_contrib_blogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.count_contrib_blogs.function_name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.portal_iac_s3_distribution.arn 
}

resource "aws_lambda_permission" "allow_cloudfront_get_number_of_modules" {
  statement_id  = "AllowExecutionFromCloudFrontToLambda_get_number_of_modules"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_number_of_modules.function_name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.portal_iac_s3_distribution.arn 
}

########### Lambda function URLs ###########

resource "aws_lambda_function_url" "get_module_repositories_url" {
  function_name      = aws_lambda_function.get_module_repositories.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "download_how_to_use_files_ul" {
  function_name      = aws_lambda_function.download_how_to_use_files.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "get_portal_data_url" {
  function_name      = aws_lambda_function.get_portal_data.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "count_contrib_blogs_url" {
  function_name      = aws_lambda_function.count_contrib_blogs.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "get_number_of_modules_url" {
  function_name      = aws_lambda_function.get_number_of_modules.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}