
# https://registry.terraform.io/modules/kaonmir/nemo-eks-cluster/aws/0.0.0?tab=inputs
module "nemo-eks-cluster" {
  source  = "kaonmir/nemo-eks-cluster/aws"
  version = "0.0.0"
  # insert the 2 required variables here
}

# https://github.com/kaonmir/terraform-aws-nemo-eks-cluster-autoscale
module "nemo-eks-cluster-autoscale" {
  source  = "kaonmir/nemo-eks-cluster-autoscale/aws"
  version = "0.0.0"
  # insert the 1 required variable here
}
