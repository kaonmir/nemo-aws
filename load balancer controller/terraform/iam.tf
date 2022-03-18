data "aws_eks_cluster" "nemo_eks_cluster" {
  name = var.cluster_name
}
data "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.nemo_eks_cluster.identity[0].oidc[0].issuer
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.serviceaccount_namespace}:${local.serviceaccount_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.oidc.arn]
      type        = "Federated"
    }
  }
}
# ---

resource "aws_iam_policy" "EKSALBController" {
  name        = "EKSALBController"
  path        = "/"
  description = "Policy for load balancer controller running on EKS"

  policy = file("${path.module}/policy.json")
}

# Making IRSA (IAM Role for Service Account)
resource "aws_iam_role" "EKSALBControllerRole" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.EKSALBController.arn]
  name                = "EKSALBControllerRole"
}
