# purpose: define networking rules for the eks cluster
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/security_group.html
# aws docs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
resource "aws_security_group" "cluster" {
  name        = "${var.NAME}-cluster"
  description = "EKS cluster "
  vpc_id      = "${aws_vpc.demo.id}"

  egress {
    description = "Allow all outbound requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OPTIONAL: Allow inbound traffic from your local workstation external IP
  #           to the Kubernetes. You will need to replace A.B.C.D below with
  #           your real IP. Services like icanhazip.com can help you find this.
  ingress {
    description = "Allow my local machine to communicate with the cluster"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    IP          = var.LOCAL_MACHINE_EXTERNAL_IP_ADDRESS
  }
}

# # This data source is included for ease of sample architecture deployment
# # and can be swapped out as necessary.
# data "aws_availability_zones" "available" {}

# resource "aws_vpc" "demo" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     "Name"                                      = "terraform-eks-demo-node"
#     "kubernetes.io/cluster/${var.cluster-name}" = "shared"
#   }
# }

# resource "aws_subnet" "demo" {
#   count = 2

#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   cidr_block        = "10.0.${count.index}.0/24"
#   vpc_id            = aws_vpc.demo.id

#   tags = {
#     "Name"                                      = "terraform-eks-demo-node"
#     "kubernetes.io/cluster/${var.cluster-name}" = "shared"
#   }
# }

# resource "aws_internet_gateway" "demo" {
#   vpc_id = aws_vpc.demo.id

#   tags = {
#     Name = "terraform-eks-demo"
#   }
# }

# resource "aws_route_table" "demo" {
#   vpc_id = aws_vpc.demo.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.demo.id
#   }
# }

# resource "aws_route_table_association" "demo" {
#   count = 2

#   subnet_id      = aws_subnet.demo[count.index].id
#   route_table_id = aws_route_table.demo.id
# }
