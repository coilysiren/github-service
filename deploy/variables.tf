variable "region" {
  default = "us-west-2"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "0000000000",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::0000000000:role/role1"
      username = "role1"
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
  }))

  default = [
    {
      userarn  = "arn:aws:iam::0000000000:user/user1"
      username = "user1"
    },
  ]
}
