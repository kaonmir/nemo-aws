terraform {
  required_version = ">= 0.13.1"
}

provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "aws"
}
