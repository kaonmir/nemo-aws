locals {
  argocd-version = "3.13.0"
  ns-argocd      = kubernetes_namespace.argocd.metadata[0].name
}


resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = local.argocd-version
  namespace  = local.ns-argocd

  values = [
    "${file("argocd.values.yaml")}"
  ]
}
