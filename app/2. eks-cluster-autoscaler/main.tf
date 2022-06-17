locals {
  region       = "ap-northeast-2"
  cluster_name = "sonjeff"
  #! 무조건 1. eks-cluster의 이름과 같아야 한다.
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster-autoscale/aws/latest
module "eks-cluster-autoscale" {
  source  = "kaonmir/nemo-eks-cluster-autoscale/aws"
  version = "0.4.0"

  aws_region   = local.region
  cluster_name = local.cluster_name
}
