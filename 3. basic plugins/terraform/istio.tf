locals {
  istio-version = "1.13.2"
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "base" {
  name       = "base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = local.istio-version
  namespace  = kubernetes_namespace.istio-system.metadata[0].name
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = local.istio-version
  namespace  = kubernetes_namespace.istio-system.metadata[0].name
}

# -----

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      istio-injection = "enabled"
    }
  }
}

locals {
  istio-ingress-value = yamlencode({
    nodeSelector = {
      role = "nodegroup_admin"
    }
    tolerations = [{
      key      = "TAINED_BY_ADMIN"
      operator = "Exists"
      effect   = "NoSchedule"
    }]
  })
}

resource "helm_release" "istio-ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = local.istio-version
  namespace  = kubernetes_namespace.istio-ingress.metadata[0].name

  values = [
    local.istio-ingress-value
  ]
}
