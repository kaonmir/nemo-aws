locals {
  region = "ap-northeast-2"
}
# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws/0.0.0?tab=inputs
module "eks-cluster" {
  source = "kaonmir/nemo-eks-cluster/aws"
  # version      = "0.1.0"
  aws_region   = local.region
  cluster_name = "nemo"
}

# https://github.com/kaonmir/terraform-aws-nemo-eks-cluster-autoscale
module "eks-cluster-autoscale" {
  source = "kaonmir/nemo-eks-cluster-autoscale/aws"
  # version      = "0.1.0"
  aws_region   = local.region
  cluster_name = "nemo"

  depends_on = [
    module.eks-cluster.cluster
  ]
}

