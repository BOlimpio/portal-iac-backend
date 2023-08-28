resource "aws_iam_policy" "lambda_access_policy" {
  name        = "lambda-access-policy"
  description = "Policy to allow CloudFront to call Lambda Function URL"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "lambda:InvokeFunction",
        Effect   = "Allow",
        Resource = "arn:aws:lambda:regiao:conta:function:nome-da-sua-funcao-lambda",
      },
    ],
  })
}

resource "aws_iam_role" "cloudfront_role" {
  name = "cloudfront-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "cloudfront_policy_attachment" {
  name       = "cloudfront-policy-attachment"
  policy_arn = aws_iam_policy.lambda_access_policy.arn
  roles      = [aws_iam_role.cloudfront_role.name]
}


############# Lambda exec role #############

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "lambda_s3_policy" {
  name = "lambda-s3-policy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
        ],
        Resource = [
          aws_s3_bucket.lambda_code_github.arn, 
          "${aws_s3_bucket.lambda_code_github.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}