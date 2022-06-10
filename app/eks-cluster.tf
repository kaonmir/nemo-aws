locals {
  region       = "ap-northeast-2"
  cluster_name = "nemo"
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws
module "eks-cluster" {
  # count  = 0 # skip
  source = "kaonmir/nemo-eks-cluster/aws"
  # version = "0.1.0"

  aws_region   = local.region
  cluster_name = local.cluster_name
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster-autoscale/aws
module "eks-cluster-autoscale" {
  # count      = 0 # skip
  depends_on = [module.eks-cluster.cluster]
  source     = "kaonmir/nemo-eks-cluster-autoscale/aws"
  # version    = "0.1.0"

  aws_region   = local.region
  cluster_name = local.cluster_name
}

# ---

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws
module "eks-cluster-2" {
  # count  = 0 # skip
  source = "kaonmir/nemo-eks-cluster/aws"
  # version = "0.1.0"

  aws_region   = local.region
  cluster_name = "semo"
}

# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster-autoscale/aws
module "eks-cluster-autoscale-2" {
  # count      = 0 # skip
  source     = "kaonmir/nemo-eks-cluster-autoscale/aws"
  depends_on = [module.eks-cluster-2.cluster]
  # version    = "0.1.0"

  aws_region   = local.region
  cluster_name = "semo"
}

