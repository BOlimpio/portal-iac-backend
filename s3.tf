resource "aws_s3_bucket" "lambda_code_github" {
  bucket = "lambda-code-github"
}

resource "aws_s3_bucket_ownership_controls" "lambda_code_github_ownership" {
  bucket = aws_s3_bucket.lambda_code_github.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_code_github_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_code_github_ownership]

  bucket = aws_s3_bucket.lambda_code_github.id
  acl    = "private"
}

######### ZIP lambda source code #########

data "archive_file" "lambda_zip_get_module_conf" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_module_data_conf"
  output_path = "${path.module}/get_module_data_conf.zip"
}

data "archive_file" "lambda_zip_download_how_to_use" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_download_how_to_use"
  output_path = "${path.module}/download_how_to_use.zip"
}

######### Upload ZIP lambda source code #########

resource "aws_s3_object" "upload_get_module_conf_object" {
  bucket       = aws_s3_bucket.lambda_code_github.id
  key          = "get_module_data_conf.zip" 
  source       = data.archive_file.lambda_zip_get_module_conf.output_path
  content_type = "application/zip"
}

resource "aws_s3_object" "upload_download_how_to_use_object" {
  bucket       = aws_s3_bucket.lambda_code_github.id
  key          = "download_how_to_use.zip"
  source       = data.archive_file.lambda_zip_download_how_to_use.output_path
  content_type = "application/zip"
}

resource "aws_s3_object" "upload_lambda_layer_object" {
  bucket       = aws_s3_bucket.lambda_code_github.id
  key          = "python-github-layer.zip"
  source       = "${path.module}/python-github-layer.zip"
  content_type = "application/zip"
}