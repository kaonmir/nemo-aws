locals {
  az_names       = data.aws_availability_zones.available.names
  subnet_numbers = [for x in range(var.number_of_subnet) : x % length(local.az_names)]
}

module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  default_vpc_name = var.project_name

  # TODO: CIDR도 var로 유동적으로 관리 vpc: /16, subnet: /24
  cidr = "10.0.0.0/16"
  azs  = [for x in local.subnet_numbers : local.az_names[x]]

  private_subnets = [for num in local.subnet_numbers : "10.0.${num}.0/24"]
  public_subnets  = [for num in local.subnet_numbers : "10.0.10${num}.0/24"]

  enable_nat_gateway = true
  create_vpc         = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
