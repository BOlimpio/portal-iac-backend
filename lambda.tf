resource "aws_lambda_function" "get_module_repositories" {
  function_name = "get-module-repositories"
  handler       = "get_module_repositories.handler"  # Substitua "lambda_handler" pelo nome do método no código Python
  runtime       = "python3.8"                        # Defina a versão do Python que você está usando
  filename      = "path/to/your/package.zip"         # Substitua pelo caminho para seu pacote .zip contendo seu código Lambda
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      GITHUB_TOKEN = "your-github-token" # Substitua pelo seu token do GitHub
    }
  }
}

resource "aws_lambda_function" "download_how_to_use_files" {
  function_name = "download-how-to-use-files"
  handler       = "download_how_to_use_files.handler"        # Substitua "lambda_handler" pelo nome do método no código Python
  runtime       = "python3.8"                                # Defina a versão do Python que você está usando
  filename      = "path/to/your/package.zip"                 # Substitua pelo caminho para seu pacote .zip contendo seu código Lambda
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      GITHUB_TOKEN = "your-github-token" # Substitua pelo seu token do GitHub
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_policy_attachment" "lambda_exec_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role.name
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