locals {
  serviceaccount_name      = "aws-load-balancer-controller"
  serviceaccount_namespace = "kube-system"
}

resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    name      = local.serviceaccount_name
    namespace = local.serviceaccount_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = "${aws_iam_role.EKSALBControllerRole.arn}"
    }
  }
  secret {
    name = kubernetes_secret.sa_secret.metadata.0.name
  }
}

resource "kubernetes_secret" "sa_secret" {
  metadata {
    name      = local.serviceaccount_name
    namespace = local.serviceaccount_namespace
  }

}
