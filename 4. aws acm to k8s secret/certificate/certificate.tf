resource "kubernetes_manifest" "cert_for_all" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "cert-for-all"
      namespace = "istio-system"
    }
    spec = {
      commonName = "*.nemo.kaonmir.xyz"
      dnsNames = [
        "*.nemo.kaonmir.xyz"
      ]
      duration = "2160h0m0s"
      issuerRef = {
        group = "awspca.cert-manager.io"
        kind  = "AWSPCAClusterIssuer"
        name  = var.root_ca_name
      }
      renewBefore = "360h0m0s"
      secretName  = "for-all"
      usages = [
        "server auth"
      ]
    }
  }
}
resource "kubernetes_manifest" "cert_for_kiali" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "cert-for-kiali"
      namespace = "istio-system"
    }
    spec = {
      commonName = "kiali.nemo.kaonmir.xyz"
      dnsNames = [
        "kiali.nemo.kaonmir.xyz"
      ]
      duration = "2160h0m0s"
      issuerRef = {
        group = "awspca.cert-manager.io"
        kind  = "AWSPCAClusterIssuer"
        name  = var.root_ca_name
      }
      renewBefore = "360h0m0s"
      secretName  = "for-kiali"
      usages = [
        "server auth"
      ]
    }
  }
}
