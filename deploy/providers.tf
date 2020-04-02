terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version                 = ">= 2.28.1"
  region                  = var.AWS_REGION
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
