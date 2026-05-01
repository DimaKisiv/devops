variable "name" {
  description = "Назва Helm-релізу Jenkins"
  type        = string
  default     = "jenkins"
}

variable "namespace" {
  description = "Namespace для Jenkins"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Версія Jenkins Helm-чарта"
  type        = string
  default     = "5.0.16"
}

variable "cluster_name" {
  description = "Назва Kubernetes-кластера"
  type        = string
}

variable "admin_username" {
  description = "Адміністративний користувач Jenkins"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Адміністративний пароль Jenkins"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "service_account_name" {
  description = "ServiceAccount для Jenkins controller і агентів"
  type        = string
  default     = "jenkins-sa"
}

variable "oidc_provider_arn" {
  description = "ARN OIDC provider для IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL OIDC provider для IRSA"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN ECR repository для push образів"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL ECR repository для push образів"
  type        = string
}