locals {
  kiali-version     = "1.30.0"
  ns-kiali-operator = kubernetes_namespace.kiali-operator.metadata[0].name
}

resource "kubernetes_namespace" "kiali-operator" {
  metadata {
    name = "kiali-operator"
  }
}

resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-operator"
  version    = local.kiali-version
  namespace  = local.ns-kiali-operator

  set {
    name  = "cr.create"
    value = "true"
  }
  set {
    name  = "cr.namespace"
    value = local.ns-istio-system
  }
}
