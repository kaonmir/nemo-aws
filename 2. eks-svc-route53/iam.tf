

data "aws_eks_cluster" "terraform_eks_cluster" {
  name = var.cluster_name
}
data "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.terraform_eks_cluster.identity[0].oidc[0].issuer
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
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

resource "aws_iam_role" "EKSExternalDNSAccessRole" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.EKSExternalDNSAccess.arn]
  name                = "EKSExternalDNSAccessRole"
}

# ---

resource "aws_iam_role_policy_attachment" "terraform_eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = aws_iam_policy.EKSExternalDNSAccess.arn
  role       = "terraform_eks_node"
}
