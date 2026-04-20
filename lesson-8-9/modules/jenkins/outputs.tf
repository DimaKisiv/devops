output "jenkins_release_name" {
  description = "Назва Jenkins Helm-релізу"
  value       = helm_release.jenkins.name
}

output "jenkins_namespace" {
  description = "Namespace Jenkins"
  value       = helm_release.jenkins.namespace
}

output "jenkins_admin_username" {
  description = "Адміністративний користувач Jenkins"
  value       = var.admin_username
}

output "jenkins_admin_password" {
  description = "Адміністративний пароль Jenkins"
  value       = var.admin_password
  sensitive   = true
}

output "jenkins_service_account_name" {
  description = "ServiceAccount Jenkins для Kubernetes агентів"
  value       = var.service_account_name
}