locals {
  region = "ap-northeast-2"
}

module "simple-nemo" {
  # count        = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.2"
  project_name = "nemo"
  aws_region   = local.region
}
