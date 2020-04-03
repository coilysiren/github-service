# purpose: get data for the default VPC
#
# terraform docs:
# - https://www.terraform.io/docs/providers/aws/d/vpc.html
# - https://www.terraform.io/docs/configuration/data-sources.html
data "aws_vpc" "default_vpc" {
  default = true
}

# purpose: define networking rules for the eks cluster
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group.html
# aws docs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
resource "aws_security_group" "cluster" {
  name        = "${var.NAME}-cluster"
  description = "EKS cluster security group"
  vpc_id      = data.aws_vpc.default_vpc.id

  # terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
  egress {
    description = "Allow all outbound requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
