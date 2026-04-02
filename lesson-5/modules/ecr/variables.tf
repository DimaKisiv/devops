variable "ecr_name" {
  description = "Назва ECR-репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Увімкнути автоматичне сканування образів при пуші"
  type        = bool
  default     = true
}
