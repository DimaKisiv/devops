output "argo_cd_release_name" {
  description = "Назва Helm-релізу Argo CD"
  value       = helm_release.argo_cd.name
}

output "argo_cd_namespace" {
  description = "Namespace Argo CD"
  value       = helm_release.argo_cd.namespace
}

output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = "${var.name}-server.${var.namespace}.svc.cluster.local"
}

output "admin_password_command" {
  description = "Команда для отримання initial admin password"
  value       = "kubectl -n ${var.namespace} get secret ${var.name}-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}