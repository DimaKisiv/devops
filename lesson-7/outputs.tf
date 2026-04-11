output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = module.s3_backend.s3_bucket_name
}

output "s3_bucket_url" {
  description = "URL S3-бакета для стейтів"
  value       = module.s3_backend.s3_bucket_url
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Список ID публічних підмереж"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Список ID приватних підмереж"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "ecr_repository_url" {
  description = "URL ECR-репозиторію"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Назва ECR-репозиторію"
  value       = module.ecr.repository_name
}

output "eks_cluster_name" {
  description = "Назва EKS-кластера"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint EKS-кластера"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_oidc_issuer" {
  description = "OIDC issuer URL для EKS-кластера"
  value       = module.eks.cluster_oidc_issuer
}

output "eks_node_role_arn" {
  description = "ARN IAM-ролі для EKS worker nodes"
  value       = module.eks.node_role_arn
}

output "kubectl_config_command" {
  description = "Команда для налаштування kubectl"
  value       = "aws eks update-kubeconfig --region eu-north-1 --name ${module.eks.cluster_name}"
}

output "ecr_push_commands" {
  description = "Команди для логіну в ECR і пушу Docker-образу"
  value = {
    login = "aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${module.ecr.repository_url}"
    tag   = "docker tag django-app:latest ${module.ecr.repository_url}:latest"
    push  = "docker push ${module.ecr.repository_url}:latest"
  }
}


