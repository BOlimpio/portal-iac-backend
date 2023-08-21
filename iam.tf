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

# Para um exemplo de interação entre contas, a seguinte política baseada em recursos 
#permite que a example função na conta da AWS 444455556666invoque o URL da função associado à função my-function:
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::444455556666:role/example"
#             },
#             "Action": "lambda:InvokeFunctionUrl",
#             "Resource": "arn:aws:lambda:us-east-1:123456789012:function:my-function",
#             "Condition": {
#                 "StringEquals": {
#                     "lambda:FunctionUrlAuthType": "AWS_IAM"
#                 }
#             }
#         }
#     ]
# }