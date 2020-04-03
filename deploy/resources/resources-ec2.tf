# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority[0].data}' '${aws_eks_cluster.cluster.id}'
USERDATA
}

# purpose: the worker nodes launch with this machine image as their base
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/ami.html
data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# purpose: this defines the launch configuration for the worker nodes
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
resource "aws_launch_configuration" "worker" {
  name_prefix          = var.NAME
  iam_instance_profile = aws_iam_instance_profile.worker.name
  image_id             = data.aws_ami.worker.id
  instance_type        = "a1.large"
  security_groups      = [aws_security_group.worker.id]
  user_data_base64     = base64encode(local.worker-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

# purpose: this configures automatic scaling for the worker nodes
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
# aws docs:
#  - https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html
#  - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html
#
# TODO: use a cfn-signal, docs:
#  - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/deploying.applications.html
#  - ??? https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html
resource "aws_autoscaling_group" "worker" {
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.worker.id
  max_size             = 2
  min_size             = 1
  name                 = var.NAME

  # despite being called "vpc zone identifier", this attribute actually takes in
  # a list of subnet ids
  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  tag {
    key                 = "name"
    value               = var.NAME
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.cluster.id}"
    value               = "owned"
    propagate_at_launch = true
  }
}
