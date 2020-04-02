# vars filled in by env vars
variable "AWS_ACCOUNT_ID" {}
variable "AWS_REGION" {}

# locally defined vars
variable "name" {
  default = "github-service"
  type    = string
}
