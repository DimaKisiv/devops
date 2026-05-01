# Global variables for the project

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for Kubernetes access."
  type        = string
  default     = null
}
