variable "name" {
  description = "Назва Helm-релізу Argo CD"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "Kubernetes namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Helm-чарта Argo CD"
  type        = string
  default     = "5.46.4"
}

variable "app_name" {
  description = "Назва Argo CD Application"
  type        = string
  default     = "django-app"
}

variable "app_namespace" {
  description = "Namespace для деплою Django-застосунку"
  type        = string
  default     = "default"
}

variable "repo_url" {
  description = "Git-репозиторій із Helm chart для Argo CD"
  type        = string
  default     = "https://github.com/DimaKisiv/DevOps.git"
}

variable "repo_target_revision" {
  description = "Гілка або тег Git-репозиторію"
  type        = string
  default     = "lesson-8-9"
}

variable "app_path" {
  description = "Шлях до Helm-чарта всередині репозиторію"
  type        = string
  default     = "lesson-8-9/charts/django-app"
}

variable "repo_username" {
  description = "Username для приватного Git-репозиторію"
  type        = string
  default     = ""
  sensitive   = true
}

variable "repo_password" {
  description = "Token або password для приватного Git-репозиторію"
  type        = string
  default     = ""
  sensitive   = true
}