resource "aws_lambda_function" "get_module_repositories" {
  function_name = "get_module_data_conf"
  handler       = "get_module_data_conf.handler"  # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.8"                        # Set the Python version you are using
  filename      = "${aws_s3_bucket.lambda_code.bucket}/get-module-data-conf.zip"    # Replace with the path to your .zip package containing your Lambda code
  role          = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
    }
  }

  depends_on = [ archive_file.lambda_zip_get_module_conf ]
}

resource "aws_lambda_function" "download_how_to_use_files" {
  function_name = "download-how-to-use-files"
  handler       = "download_how_to_use_files.handler"        # Replace "lambda_handler" with method name in Python code
  runtime       = "python3.8"                                # Set the Python version you are using
  filename      = "${aws_s3_bucket.lambda_code.bucket}/download-how-to-use.zip"   # Replace with the path to your .zip package containing your Lambda code
  role          = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      GITHUB_TOKEN = "your-github-token" # Replace with your GitHub token
    }
  }

  depends_on = [ archive_file.lambda_zip_download_how_to_use ]
}


########### Lambda Permission ###########

resource "aws_lambda_permission" "allow_cloudfront" {
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "edgelambda.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.my_distribution.arn // <------------ ToDO
}

########### Lambda function URLs ###########

resource "aws_lambda_function_url" "get_module_repositories_url" {
  function_name      = aws_lambda_function.get_module_repositories.function_name
  qualifier          = "get_module_repositories_url"
  authorization_type = "AWS_IAM"
}

resource "aws_lambda_function_url" "download_how_to_use_files_ul" {
  function_name      = aws_lambda_function.download_how_to_use_files.function_name
  qualifier          = "download_how_to_use_files_ul"
  authorization_type = "AWS_IAM"
}