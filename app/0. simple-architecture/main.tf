locals {
  region = "ap-northeast-2"
}

# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws/0.6.2
module "simple-nemo" {
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.2"
  project_name = "son"
  aws_region   = local.region
}

# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws/0.6.2
module "simple-nemo2" {
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.2"
  project_name = "son2"
  aws_region   = local.region
  image = {
    registry   = "value"
    repository = "value"
    tag        = "value"
  }

  app = {
    allow_http_access  = false
    allow_https_access = false
    certificate_arn    = "value"
    port               = 1
  }
}
