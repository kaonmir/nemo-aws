terraform {
  required_version = ">= 0.12"
}

module "nemo_simple" {
  source       = "../0. simple-aws-architecutre"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"
}
