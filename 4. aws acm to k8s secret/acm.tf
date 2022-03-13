resource "aws_acmpca_certificate_authority" "nemo_ca" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name  = "nemo coperate"
      country      = "KR"
      organization = "nemo"
      state        = "Seoul"
    }
  }

  type = "ROOT"

  permanent_deletion_time_in_days = 7
}

resource "aws_acmpca_certificate_authority_certificate" "nemo_cac" {
  certificate_authority_arn = aws_acmpca_certificate_authority.nemo_ca.arn

  certificate       = aws_acmpca_certificate.nemo_cert.certificate
  certificate_chain = aws_acmpca_certificate.nemo_cert.certificate_chain
}

resource "aws_acmpca_certificate" "nemo_cert" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.nemo_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.nemo_ca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 1
  }
}

data "aws_partition" "current" {}
