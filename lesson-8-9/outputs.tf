output "ecr_repository_url" {
  description = "ECR repository URL for Jenkins pushes"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "Created EKS cluster name"
  value       = module.eks.cluster_name
}

output "kubectl_config_command" {
  description = "Command to configure kubectl for EKS"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = module.jenkins.namespace
}

output "jenkins_url" {
  description = "Jenkins service URL inside cluster"
  value       = module.jenkins.url_hint
}

output "jenkins_admin_username" {
  description = "Jenkins admin username"
  value       = module.jenkins.admin_username
}

output "jenkins_admin_password" {
  description = "Jenkins admin password"
  value       = module.jenkins.admin_password
  sensitive   = true
}

output "argocd_url_hint" {
  description = "Command to get Argo CD server service"
  value       = module.argo_cd.url_hint
}

output "argocd_admin_password_command" {
  description = "Command to get Argo CD initial admin password"
  value       = module.argo_cd.admin_password_command
}