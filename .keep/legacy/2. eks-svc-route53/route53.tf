data "aws_route53_zone" "eks_nemo" {
  name = var.route53_domain
}
