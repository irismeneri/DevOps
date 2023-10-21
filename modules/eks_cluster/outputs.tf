output "eks_cluster_name" {
  description = "Grupi 4"
  value       = aws_eks_cluster.eks_cluster.name
}
output "eks_cluster_role" {
  value = aws_iam_role.eks-iam-role
}
output "worker-nodes" {
  value = aws_iam_role.workernodes
}

