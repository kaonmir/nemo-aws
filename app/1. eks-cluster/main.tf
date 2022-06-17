locals {
  region       = "ap-northeast-2"
  cluster_name = "sonjeff"
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws/latest
module "eks-cluster" {
  source  = "kaonmir/nemo-eks-cluster/aws"
  version = "0.10.2"

  aws_region       = local.region
  cluster_name     = local.cluster_name
  make_kube_config = true

  admin_ec2_type = "t3.medium"
  app_ec2_type   = "t3.medium"

  app_auto_scaling_group = {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }
}
