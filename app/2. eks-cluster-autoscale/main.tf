locals {
  region       = "ap-northeast-2"
  cluster_name = "nemo"
}

module "eks-cluster-autoscale" {
  source  = "kaonmir/nemo-eks-cluster-autoscale/aws"
  version = "0.3.0"

  aws_region   = local.region
  cluster_name = local.cluster_name
}
