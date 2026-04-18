output "namespace" {
  description = "Argo CD namespace"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "url_hint" {
  description = "Hint to get Argo CD service URL"
  value       = "kubectl get svc -n ${kubernetes_namespace_v1.this.metadata[0].name}"
}

output "admin_password_command" {
  description = "Command to get Argo CD initial admin password"
  value       = "kubectl -n ${kubernetes_namespace_v1.this.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\""
}