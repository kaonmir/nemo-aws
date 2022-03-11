resource "aws_iam_role" "terraform_eks_node" {
  name = "terraform_eks_node"

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

resource "aws_iam_role_policy_attachment" "terraform_eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.terraform_eks_node.name
}

resource "aws_iam_role_policy_attachment" "terraform_eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.terraform_eks_node.name
}

resource "aws_iam_role_policy_attachment" "terraform_eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.terraform_eks_node.name
}

# t3 small node group
resource "aws_eks_node_group" "nodegroup_1" {
  cluster_name    = aws_eks_cluster.terraform_eks_cluster.name
  node_group_name = "nodegroup_1"
  node_role_arn   = aws_iam_role.terraform_eks_node.arn
  subnet_ids      = aws_subnet.terraform_eks_private_subnet[*].id
  instance_types  = [var.nodegroup_instance_type]
  disk_size       = 20

  labels = {
    "role" = "nodegroup_1"
  }

  scaling_config {
    desired_size = var.nodegroup_instance_desired_size
    min_size     = max(var.nodegroup_instance_desired_size - 1, 0)
    max_size     = var.nodegroup_instance_desired_size + 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform_eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.terraform_eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.terraform_eks_node_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "Name" = "${aws_eks_cluster.terraform_eks_cluster.name}_terraform_eks_Node"
  }
}

