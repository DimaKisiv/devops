output "cluster_name" {
  description = "Назва EKS-кластера"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN EKS-кластера"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Endpoint EKS-кластера"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded CA certificate EKS-кластера"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL EKS-кластера"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role_arn" {
  description = "ARN IAM-ролі для worker nodes"
  value       = aws_iam_role.node_group.arn
}

output "oidc_provider_arn" {
  description = "ARN OIDC provider для IRSA"
  value       = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  description = "URL OIDC provider для IRSA"
  value       = aws_iam_openid_connect_provider.oidc.url
}

output "node_group_name" {
  description = "Назва node group"
  value       = aws_eks_node_group.this.node_group_name
}