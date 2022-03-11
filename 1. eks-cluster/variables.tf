variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "nodegroup_instance_type" {
  type    = string
  default = "t3.small"
}

