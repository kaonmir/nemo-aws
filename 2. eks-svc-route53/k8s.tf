resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "${aws_iam_role.EKSExternalDNSAccessRole.arn}"
    }
  }
  secret {
    name = kubernetes_secret.external_dns_secret.metadata.0.name
  }
}

resource "kubernetes_secret" "external_dns_secret" {
  metadata {
    name      = "external-dns-secret"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["networking.istio.io", "networking.istio.io/v1alpha3"]
    resources  = ["gateways", "virtualservices"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "watch"]
  }
}
resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
  metadata {
    name = "external-dns-viewer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-dns"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "external-dns"
    namespace = "kube-system"
  }
}
resource "kubernetes_deployment" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
  }

  spec {
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "external-dns"
      }
    }
    template {
      metadata {
        labels = {
          app = "external-dns"
        }
      }
      spec {
        service_account_name = "external-dns"
        security_context {
          fs_group = 65534
        }
        container {
          image = "registry.opensource.zalan.do/teapot/external-dns:latest"
          name  = "external-dns"
          args = [
            "--source=service",
            "--source=ingress",
            "--source=istio-gateway",
            "--source=istio-virtualservice",
            "--domain-filter=${var.route_53_domain}", # will make ExternalDNS see only the hosted zones matching provided domain, omit to process all available hosted zones
            "--provider=aws",
            "--policy=upsert-only",   # would prevent ExternalDNS from deleting any records, omit to enable full synchronization
            "--aws-zone-type=public", # only look at public hosted zones (valid values are public, private or no value for both)
            "--registry=txt",
            "--txt-owner-id=${data.aws_route53_zone.eks_nemo.zone_id}"
          ]
        }
      }
    }
  }
}
