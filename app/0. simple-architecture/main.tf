locals {
  region = "ap-northeast-2"
}

# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws/latest
module "simple-nemo" {
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.7.0"
  project_name = "son"
  aws_region   = local.region
}
