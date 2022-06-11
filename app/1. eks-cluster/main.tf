locals {
  region       = "ap-northeast-2"
  cluster_name = "nemo-kube"
}

module "eks-cluster" {
  source  = "kaonmir/nemo-eks-cluster/aws"
  version = "0.10.0"

  aws_region       = local.region
  cluster_name     = local.cluster_name
  make_kube_config = true
}
