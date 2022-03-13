resource "aws_acm_certificate" "cert" {
  domain_name       = concat("*.", var.route_53_domain)
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}
