resource "aws_eks_node_group" "portwork-workers" {
  cluster_name    = aws_eks_cluster.portwork-cluster.name
  node_group_name = "portwork-workers"
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      = module.vpc.public_subnets
  launch_template {
    id = aws_launch_template.worker-launch-template.id
    version = "$Latest"
  }
  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  update_config {
    max_unavailable = 1
  }
  # remote_access {
  #   source_security_group_ids = [aws_security_group.worker-sg.id]
  # }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy,
  ]
}


resource "aws_iam_role" "worker_role" {
  name = "terraform-eks-demo-node"

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

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_role.name
}
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_role_policy_attachment" "sqs_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
#   role       = aws_iam_role.worker_role.name
# }

resource "aws_launch_template" "worker-launch-template" {
  name = "worker-launch-template"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  block_device_mappings {
    device_name = "/dev/sdh"
    ebs {
      volume_size = 50
      delete_on_termination = true
    }
  }
  vpc_security_group_ids   = [aws_security_group.worker-sg.id]
  # user_data = "${base64encode(data.template_file.user_data.rendered)}"
}

# data "local_file" "public_ssh_key" {
#   filename = "/home/mc/.ssh/id_rsa.pub"
# }

# data "template_file" "user_data" {
#   template = <<-EOF
#     #!/bin/bash
#     sudo -u ec2-user bash -c 'echo "${data.local_file.public_ssh_key.content}" >> ~/.ssh/authorized_keys'
#     EOF
# }
resource "aws_security_group" "worker-sg" {
  name        = "${var.cluster_name}-worker-sg"
  description = "Worker nodes security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow connection to cluster api server
  ingress {
    from_port = 9001
    to_port = 9022
    protocol = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9002
    to_port = 9002
    protocol = "udp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.cluster_sg.id]
  }
}