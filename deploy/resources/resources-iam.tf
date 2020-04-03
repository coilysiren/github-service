# purpose: the eks cluster runs as this role
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/iam_role.html
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

# purpose: attach builtin aws eks cluster policy to our locally created role
#
# terraform docs:https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role.name
}

# purpose: attach builtin aws eks service policy to our locally created role
#
# terraform docs:https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role.name
}
