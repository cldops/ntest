# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * Security group for allowing incoming connections to nodes
#  * EKS Node Group to launch worker nodes

resource "aws_iam_role" "ntest-node" {
  name = "terraform-eks-ntest-node"

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

resource "aws_iam_role_policy_attachment" "ntest-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ntest-node.name
}

resource "aws_iam_role_policy_attachment" "ntest-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ntest-node.name
}

resource "aws_iam_role_policy_attachment" "ntest-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ntest-node.name
}

resource "aws_eks_node_group" "ntest" {
  cluster_name    = aws_eks_cluster.ntest.name
  node_group_name = "ntest"
  instance_types  = ["t2.small"]
  node_role_arn   = aws_iam_role.ntest-node.arn
  subnet_ids      = aws_subnet.ntest[*].id

remote_access {
    ec2_ssh_key   = "rvirgp"
  }

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.ntest-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ntest-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.ntest-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
