terraform {
  required_version = ">= 0.13.1"
}

provider "aws" {
  region = local.region
}
