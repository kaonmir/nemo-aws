
# https://registry.terraform.io/modules/kaonmir/simple-architecture/aws
module "simple" {
  # count  = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.5.0"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"

  image = {
    registry   = "value"
    repository = "value"
    tag        = "value"
  }
}
