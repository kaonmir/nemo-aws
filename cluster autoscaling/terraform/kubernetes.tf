locals {
  serviceaccount-name      = "cluster-autoscaler"
  serviceaccount-namespace = "kube-system"
}

resource "kubernetes_service_account" "cluster-autoscaler" {
  metadata {
    name      = local.serviceaccount-name
    namespace = local.serviceaccount-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = "${aws_iam_role.k8s-asg-policy.arn}"
    }
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  secret {
    name = kubernetes_secret.cluster-autoscaler.metadata.0.name
  }
}

resource "kubernetes_secret" "cluster-autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }

}
