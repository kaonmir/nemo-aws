
resource "aws_iam_policy" "EKSAWSPCAIssuer" {
  name        = "EKSAWSPCAIssuer"
  path        = "/"
  description = "Policy to access AWS PCA"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "awspcaissuer",
        Action = [
          "acm-pca:DescribeCertificateAuthority",
          "acm-pca:GetCertificate",
          "acm-pca:IssueCertificate"
        ],
        Effect   = "Allow",
        Resource = aws_acmpca_certificate_authority.nemo_ca.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nemo_eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = aws_iam_policy.EKSAWSPCAIssuer.arn
  role       = "nemo_eks_node"
}
