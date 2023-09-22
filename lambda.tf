# AWS Lambda filename.method_name as handler format.

resource "aws_lambda_function" "get_module_repositories" {
  description = "Function that will get the information of all modules that start with prefix 'm-portal-' and have the file 'module-data.conf'"
  function_name = "get_module_data_conf"
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

  depends_on = [ data.archive_file.lambda_zip_get_module_conf ]
}

resource "aws_lambda_function" "download_how_to_use_files" {
  description   = "Function that receives the name of the repository as a parameter and downloads the files in the 'how-to-use' folder"
  function_name = "download-how-to-use"
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

  depends_on = [ data.archive_file.lambda_zip_download_how_to_use ]
}

resource "aws_lambda_function" "get_portal_data" {
  description   = "Function that receives the folder name of the content as a parameter and retrive information about blogs post or contributors"
  function_name = "get_portal_data"
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

  depends_on = [ data.archive_file.lambda_zip_download_how_to_use ]
}

resource "aws_lambda_layer_version" "github_lambda_layer" {
  filename = aws_s3_object.upload_lambda_layer_object.source
  layer_name = "lambda_layer"
  compatible_runtimes = ["python3.7"]
}


########### Lambda Permission ###########

# resource "aws_lambda_permission" "allow_cloudfront" {
#   statement_id  = "AllowExecutionFromCloudFront"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.my_lambda_function.function_name
#   principal     = "edgelambda.amazonaws.com"
#   source_arn    = aws_cloudfront_distribution.my_distribution.arn // <------------ ToDO
# }

# resource "aws_lambda_permission" "allow_cloudfront" {
#   statement_id  = "AllowExecutionFromCloudFront"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.my_lambda_function.function_name
#   principal     = "edgelambda.amazonaws.com"
#   source_arn    = aws_cloudfront_distribution.my_distribution.arn // <------------ ToDO
# }

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