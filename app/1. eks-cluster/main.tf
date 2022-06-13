locals {
  region       = "ap-northeast-2"
  cluster_name = "sonjeff"
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws/0.10.0
module "eks-cluster" {
  source  = "kaonmir/nemo-eks-cluster/aws"
  version = "0.10.0"

  aws_region       = local.region
  cluster_name     = local.cluster_name
  make_kube_config = true

  admin_ec2_type = "t3.medium"
  app_ec2_type   = "t3.medium"
}
