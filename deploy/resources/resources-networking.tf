# purpose: get (not create) the resource for the default VPC
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/default_vpc.html
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# purpose: get the default subnets
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/subnet.html
data "aws_subnet_ids" "default" {
  vpc_id = aws_default_vpc.default.id
}

# purpose: define networking rules for the eks cluster
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group.html
# aws docs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
resource "aws_security_group" "cluster" {
  name        = "${var.NAME}-cluster"
  description = "EKS cluster security group"
  vpc_id      = aws_default_vpc.default.id

  # terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
  egress {
    description = "Allow all outbound requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# purpose: k8s worker node security group
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group.html
# aws docs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
resource "aws_security_group" "worker" {
  name        = "${var.NAME}-eks-worker-node"
  description = "k8s worker node security group"
  vpc_id      = aws_default_vpc.default.id

  # terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
  egress {
    description = "Allow all outbound requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# purpose: allow nodes to communicate with each other
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "worker_node_self_ingress" {
  description              = "allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  type                     = "ingress"
}

# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "cluster_to_worker_ingress" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.cluster.id
  type                     = "ingress"
}

# terraform docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "worker_to_cluster_ingress" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.worker.id
  type                     = "ingress"
}
