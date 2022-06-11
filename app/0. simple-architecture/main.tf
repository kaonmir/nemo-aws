locals {
  region = "ap-northeast-2"
}

module "simple-demo" {
  # count        = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.1"
  project_name = "demo"
  aws_region   = local.region
}
