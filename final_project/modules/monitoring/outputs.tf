output "grafana_admin_password_command" {
  description = "Command to get Grafana admin password."
  value = "kubectl get secret --namespace ${var.namespace} grafana -o jsonpath=\"{.data.admin-password}\" | base64 --decode"
}

output "grafana_service_name" {
  description = "Grafana service name."
  value       = helm_release.grafana.name
}

output "prometheus_service_name" {
  description = "Prometheus service name."
  value       = helm_release.prometheus.name
}
