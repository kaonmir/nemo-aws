data "aws_ssm_parameter" "foo" {
  name = "config/eks/ArgocdInitPassword"
}

output "password" {
  value = data.aws_ssm_parameter.foo
}
