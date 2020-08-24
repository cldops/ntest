# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster

resource "aws_iam_role" "ntest-cluster" {
  name = "terraform-eks-ntest-cluster"

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

resource "aws_iam_role_policy_attachment" "ntest-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ntest-cluster.name
}

resource "aws_security_group" "ntest-cluster" {
  name        = "terraform-eks-ntest-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.ntest.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-ntest"
  }
}

resource "aws_eks_cluster" "ntest" {
  name     = var.cluster-name
  role_arn = aws_iam_role.ntest-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.ntest-cluster.id]
    subnet_ids         = aws_subnet.ntest[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.ntest-cluster-AmazonEKSClusterPolicy,
  ]
}
