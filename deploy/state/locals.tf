# vars filled in by env vars
variable "NAME" {}
variable "AWS_ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "STATE_BUCKET_REGION" {}
variable "STATE_BUCKET_NAME" {}

# aws access configuration
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  region                  = var.STATE_BUCKET_REGION
}

terraform {
  # set the local state backend, for bootstrapping the s3 state
  # docs: https://www.terraform.io/docs/backends/types/local.html
  required_version = ">= 0.12.0"
  backend "local" {}
}
