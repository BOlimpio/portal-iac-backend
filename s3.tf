resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code"
  acl    = "private"
}

######### ZIP lambda source code #########

resource "archive_file" "lambda_zip_get_module_conf" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_module_data_conf"
  output_path = "${path.module}/get-module-data-conf.zip"
}

resource "archive_file" "lambda_zip_download_how_to_use" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_download_how_to_use"
  output_path = "${path.module}/download-how-to-use.zip"
}

######### Upload ZIP lambda source code #########

resource "aws_s3_bucket_object" "upload_get_module_conf_object" {
  bucket       = aws_s3_bucket.lambda_code.id
  key          = "get-module-data-conf.zip" 
  source       = archive_file.lambda_zip_get_module_conf.output_path
  content_type = "application/zip"
}

resource "aws_s3_bucket_object" "upload_download_how_to_use_object" {
  bucket       = aws_s3_bucket.lambda_code.id
  key          = "download-how-to-use.zip"
  source       = archive_file.lambda_zip_download_how_to_use.output_path
  content_type = "application/zip"
}