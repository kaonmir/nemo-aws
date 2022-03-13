# -- Creating Root CA using AWS PCA
resource "kubernetes_manifest" "nemo-root-ca" {
  manifest = {
    apiVersion = "awspca.cert-manager.io/v1beta1"
    kind       = "AWSPCAClusterIssuer"
    metadata = {
      name = "nemo-root-ca"
    }
    spec = {
      arn    = aws_acmpca_certificate_authority.nemo_ca.arn
      region = var.aws_region
    }
  }
}

# -- Below are the certificate using upper Root CA


