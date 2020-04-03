# purpose: stand up the eks cluster
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/eks_cluster.html
resource "aws_eks_cluster" "cluster" {
  name     = var.NAME
  role_arn = aws_iam_role.role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids         = data.aws_subnet_ids.default.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.service_policy,
  ]

  # # update kubeconfig
  # provisioner "local-exec" {
  #   command = "aws eks update-kubeconfig --name ${var.NAME}"
  # }
}
