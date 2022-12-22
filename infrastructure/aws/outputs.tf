output "endpoint" {
  value = aws_eks_cluster.portwork-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.portwork-cluster.certificate_authority[0].data
}