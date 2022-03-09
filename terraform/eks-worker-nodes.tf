resource "aws_iam_role" "terraform-eks-node" {
  name = "terraform-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.terraform-eks-node.name
}

resource "aws_iam_role_policy_attachment" "terraform-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.terraform-eks-node.name
}

resource "aws_iam_role_policy_attachment" "terraform-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.terraform-eks-node.name
}

# t3 small node group
resource "aws_eks_node_group" "terraform-eks-t3-small" {
  cluster_name    = aws_eks_cluster.terraform-eks-cluster.name
  node_group_name = "terraform-eks-t3-small"
  node_role_arn   = aws_iam_role.terraform-eks-node.arn
  subnet_ids      = aws_subnet.terraform-eks-private-subnet[*].id
  instance_types  = ["t3.medium"]
  disk_size       = 20

  labels = {
    "role" = "terraform-eks-t3-small"
  }

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform-eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.terraform-eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.terraform-eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "Name" = "${aws_eks_cluster.terraform-eks-cluster.name}-terraform-eks-t3-small-Node"
  }
}

