terraform {
  backend "s3" {
    bucket         = "poc-projects-terraform-statefile"
    key            = "global/terraform-portal-iac.tfstate"
    region         = "us-east-1"
  }
}