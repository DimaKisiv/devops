output "namespace" {
  description = "Jenkins namespace"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "url_hint" {
  description = "Hint to get Jenkins service URL"
  value       = "kubectl get svc -n ${kubernetes_namespace_v1.this.metadata[0].name}"
}

output "admin_username" {
  description = "Jenkins admin username"
  value       = var.admin_username
}

output "admin_password" {
  description = "Jenkins admin password"
  value       = var.admin_password
  sensitive   = true
}