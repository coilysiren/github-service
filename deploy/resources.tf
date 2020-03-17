resource "aws_security_group" "worker_management" {
  name_prefix = "worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "TODO",
    ]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "test-vpc"
  cidr                 = "TODO"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["TODO"]
  public_subnets       = ["TODO"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

module "eks" {
  source       = "../.."
  cluster_name = var.name
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                 = "worker-group-2"
      instance_type        = "t2.medium"
      asg_desired_capacity = 1
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.worker_management.id]
  map_accounts = [
    var.AWS_ACCOUNT_ID,
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
