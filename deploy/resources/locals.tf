# vars filled in by env vars
variable "AWS_ACCOUNT_ID" {}
variable "AWS_REGION" {}

# locally defined vars
variable "name" {
  default = "github-service"
  type    = string
}

# aws access configuration
provider "aws" {
  version                 = ">= 2.28.1"
  region                  = var.AWS_REGION
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

# set the s3 state backend
# docs: https://www.terraform.io/docs/backends/types/s3.html
terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket = "github-service-state-bucket"
    key    = "terraform.tfstate"
  }
}
