locals {
  region       = "ap-northeast-2"
  cluster_name = "nemo"
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster-autoscale/aws/0.4.0
module "eks-cluster-autoscale" {
  source  = "kaonmir/nemo-eks-cluster-autoscale/aws"
  version = "0.4.0"

  aws_region   = local.region
  cluster_name = local.cluster_name
}
