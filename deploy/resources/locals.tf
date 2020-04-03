# vars filled in by env vars
variable "NAME" {}
variable "LOCAL_MACHINE_EXTERNAL_CIDR" {}
variable "AWS_ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "STATE_BUCKET_REGION" {}
variable "STATE_BUCKET_NAME" {}

# aws access configuration
provider "aws" {
  version                 = "~> 2.55"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  region                  = var.AWS_REGION
}

terraform {
  # set the s3 state backend
  # docs: https://www.terraform.io/docs/backends/types/s3.html
  required_version = ">= 0.12.0"
  backend "s3" {}
}
