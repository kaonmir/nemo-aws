
module "simple-demo" {
  # count  = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.5.0"
  project_name = "demo"
  aws_region   = "ap-northeast-2"
}

module "simple-nemo" {
  # count  = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.5.0"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"

  image = {
    registry   = "774026503161.dkr.ecr.ap-northeast-2.amazonaws.com"
    repository = "nemo-smart"
    tag        = "latest"
  }
}
