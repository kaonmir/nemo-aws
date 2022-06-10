module "simple-demo" {
  count        = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.1"
  project_name = "demo"
  aws_region   = "ap-northeast-2"
}

module "simple-nemo" {
  count        = 0 # skip
  source       = "kaonmir/simple-architecture/aws"
  version      = "0.6.1"
  project_name = "nemo"
  aws_region   = "ap-northeast-2"

  # 스마트 신안 이미지로 서버를 실행
  image = {
    registry   = "774026503161.dkr.ecr.ap-northeast-2.amazonaws.com"
    repository = "nemo-smart"
    tag        = "latest"
  }

  app = {
    allow_http_access  = true
    allow_https_access = false
    certificate_arn    = ""
    port               = 8080
  }
}
