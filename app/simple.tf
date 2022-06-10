
# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws
module "simple" {
  # count  = 0 # skip
  source = "kaonmir/simple-architecture/aws"
  # version      = "0.2.0"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"
}
