resource "aws_eks_cluster" "portwork-cluster" {
  name     = "portwork-cluster"
  role_arn = aws_iam_role.portwork-cluster-role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
    security_group_ids = [aws_security_group.cluster_sg.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.service_policy,
  ]
}

resource "aws_iam_role" "portwork-cluster-role" {
  name = "${var.cluster_name}-eks-role"

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

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.portwork-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.portwork-cluster-role.name
}

resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-eks-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow connection to cluster api server
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9001
    to_port = 9001
    protocol = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.cluster_name
  }
}

# resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
#   cidr_blocks       = ["0.0.0.0/0"]
#   description       = "Allow workstation to communicate with the cluster API Server"
#   from_port         = 443
#   protocol          = "tcp"
#   security_group_id = aws_security_group.cluster_sg.id
#   to_port           = 443
#   type              = "ingress"
# }

