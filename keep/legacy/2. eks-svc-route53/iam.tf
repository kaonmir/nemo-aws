

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
      values   = ["system:serviceaccount:kube-system:external-dns"]
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

resource "aws_iam_policy" "EKSExternalDNSAccess" {
  name        = "EKSExternalDNSAccess"
  path        = "/"
  description = "Policy to access Route53"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["route53:ChangeResourceRecordSets"],
        Resource = ["arn:aws:route53:::hostedzone/*"]
      },
      {
        Effect   = "Allow",
        Action   = ["route53:ListHostedZones", "route53:ListResourceRecordSets"],
        Resource = ["*"]
      }
    ]
  })
}

# Making IRSA (IAM Role for Service Account)
resource "aws_iam_role" "EKSExternalDNSAccessRole" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.EKSExternalDNSAccess.arn]
  name                = "EKSExternalDNSAccessRole"
}

# Attaching IAM policy to EKS Worker node
resource "aws_iam_role_policy_attachment" "nemo_eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = aws_iam_policy.EKSExternalDNSAccess.arn
  role       = "nemo_eks_node"
}
