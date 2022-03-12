resource "aws_iam_role" "terraform_eks_cluster" {
  name = "terraform_eks_cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform_eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform_eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "terraform_eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.terraform_eks_cluster.name
}

resource "aws_security_group" "terraform_eks_cluster" {
  name        = "terraform_eks_cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.terraform_eks_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_eks_cluster"
  }
}

resource "aws_security_group_rule" "terraform_eks_cluster_ingress_workstation_https" {
  cidr_blocks       = ["10.110.0.0/16"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.terraform_eks_cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "terraform_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.terraform_eks_cluster.arn
  version  = "1.21"

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = [aws_security_group.terraform_eks_cluster.id]
    subnet_ids              = concat(aws_subnet.terraform_eks_public_subnet[*].id, aws_subnet.terraform_eks_private_subnet[*].id)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform_eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.terraform_eks_cluster_AmazonEKSVPCResourceController,
  ]
}

data "tls_certificate" "terraform_cert" {
  url = aws_eks_cluster.terraform_eks_cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.terraform_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.terraform_eks_cluster.identity[0].oidc[0].issuer
}

resource "local_file" "kube_config" {
  content = replace(yamlencode({
    apiVersion = "v1",
    clusters = [
      {
        cluster = {
          certificate-authority-data = aws_eks_cluster.terraform_eks_cluster.certificate_authority[0].data
          server                     = aws_eks_cluster.terraform_eks_cluster.endpoint
        },
        name = "kubernetes"
      }
    ],
    contexts = [
      {
        context = {
          cluster   = "kubernetes",
          namespace = "default",
          user      = "aws"
        },
        name = "aws"
      }
    ],
    current-context = "aws",
    kind            = "Config",
    preferences     = {},
    users = [
      {
        name = "aws",
        user = {
          exec = {
            apiVersion = "client.authentication.k8s.io/v1alpha1",
            args = [
              "eks",
              "get-token",
              "--cluster-name",
              aws_eks_cluster.terraform_eks_cluster.name
            ],
            command            = "aws",
            env                = null,
            interactiveMode    = "IfAvailable",
            provideClusterInfo = false
          }
        }
      }
    ]
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
  filename = pathexpand("~/.kube/config")
}
