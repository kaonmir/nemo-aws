terraform {
  required_version = ">= 0.12"
}

# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws/0.0.0
# https://github.com/kaonmir/terraform-aws-simple-architecture/releases/tag/v0.0.0
module "nemo_simple" {
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.1.0"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"
}
