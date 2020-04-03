# purpose: the eks cluster runs as this role
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/iam_role.html
# aws docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
resource "aws_iam_role" "role" {
  name        = var.NAME
  description = "the eks cluster runs as this role"

  # would really prefer if this was in yaml
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# purpose: attach the aws managed eks (cluster + service) policies to our cluster role
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# aws docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role.name
}
resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role.name
}

# purpose: the ec2 worker instances for eks run as this role
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/iam_role.html
# aws docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
resource "aws_iam_role" "worker" {
  name        = "${var.NAME}-worker-role"
  description = "the ec2 worker instances for eks run as this role"

  # would really prefer if this was in yaml
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# purpose: attach the aws managed eks reccommended worker policies to our worker role
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# aws docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}
resource "aws_iam_role_policy_attachment" "CNI_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}
resource "aws_iam_role_policy_attachment" "container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

# terraform docs: https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
resource "aws_iam_instance_profile" "worker" {
  name = var.NAME
  role = aws_iam_role.worker.name
}
