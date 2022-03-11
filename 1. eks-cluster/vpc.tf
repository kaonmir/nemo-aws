locals {
  alphabets = ["a", "b", "c", "d"]
}

resource "aws_vpc" "terraform_eks_vpc" {
  cidr_block = "10.110.0.0/16"

  tags = {
    "Name"                                      = "terraform_eks_node"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_eip" "terraform_eks_eip" {
  vpc = true
  tags = {
    "Name" = "terraform_eks_public_nat_gateway"
  }
}

resource "aws_nat_gateway" "terraform_eks_nat_gateway" {
  allocation_id = aws_eip.terraform_eks_eip.id
  subnet_id     = aws_subnet.terraform_eks_public_subnet[0].id

  tags = {
    "Name" = "terraform_eks_nat_gateway"
  }
}

# public subnet
resource "aws_subnet" "terraform_eks_public_subnet" {
  count = var.number_of_subnet

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.110.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.terraform_eks_vpc.id

  tags = {
    "Name"                                      = "terraform_eks_public_${local.alphabets[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# private subnet
resource "aws_subnet" "terraform_eks_private_subnet" {
  count = var.number_of_subnet

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.110.1${count.index + 1}.0/24"
  vpc_id            = aws_vpc.terraform_eks_vpc.id

  tags = {
    "Name"                                      = "terraform_eks_private_${local.alphabets[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# trust subnet
resource "aws_subnet" "terraform_eks_trust_subnet" {
  count = var.number_of_subnet

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.110.11${count.index + 1}.0/24"
  vpc_id            = aws_vpc.terraform_eks_vpc.id

  tags = {
    "Name"                                      = "terraform_eks_trust_${local.alphabets[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "terraform_eks_igw" {
  vpc_id = aws_vpc.terraform_eks_vpc.id

  tags = {
    Name = "terraform_eks_igw"
  }
}

# public route table
resource "aws_route_table" "terraform_eks_public_route" {
  vpc_id = aws_vpc.terraform_eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_eks_igw.id
  }

  tags = {
    "Name" = "terraform_eks_public"
  }
}

# private route table
resource "aws_route_table" "terraform_eks_private_route" {
  vpc_id = aws_vpc.terraform_eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_eks_nat_gateway.id
  }

  tags = {
    "Name" = "terraform_eks_private"
  }
}

# trust route table
resource "aws_route_table" "terraform_eks_trust_route" {
  vpc_id = aws_vpc.terraform_eks_vpc.id

  tags = {
    "Name" = "terraform_eks_trust"
  }
}


# public route table association
resource "aws_route_table_association" "terraform_eks_public_routing" {
  count = var.number_of_subnet

  subnet_id      = aws_subnet.terraform_eks_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_eks_public_route.id
}

# private route table association
resource "aws_route_table_association" "terraform_eks_private_routing" {
  count = var.number_of_subnet

  subnet_id      = aws_subnet.terraform_eks_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_eks_private_route.id
}

# trust route table association
resource "aws_route_table_association" "terraform_eks_trust_routing" {
  count = var.number_of_subnet

  subnet_id      = aws_subnet.terraform_eks_trust_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_eks_trust_route.id
}
