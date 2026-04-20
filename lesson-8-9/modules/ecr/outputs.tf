output "repository_url" {
  description = "URL ECR-репозиторію"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "Назва ECR-репозиторію"
  value       = aws_ecr_repository.this.name
}

output "repository_arn" {
  description = "ARN ECR-репозиторію"
  value       = aws_ecr_repository.this.arn
}
