variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "namespace" {
  description = "Jenkins namespace"
  type        = string
}

variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
}

variable "admin_username" {
  description = "Jenkins admin username"
  type        = string
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "Git username used by Jenkins"
  type        = string
}

variable "github_email" {
  description = "Git email used by Jenkins"
  type        = string
}

variable "github_token" {
  description = "Git token used by Jenkins"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWS access key for Kaniko"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret key for Kaniko"
  type        = string
  sensitive   = true
}

variable "app_repo_url" {
  description = "Repository with application source and Jenkinsfile"
  type        = string
}

variable "gitops_repo_url" {
  description = "Repository with Helm chart monitored by Argo CD"
  type        = string
}

variable "git_branch" {
  description = "Git branch used by pipeline"
  type        = string
}

variable "ecr_repository_url" {
  description = "Target ECR repository URL"
  type        = string
}

variable "app_context_path" {
  description = "Path to Docker build context inside repository"
  type        = string
}

variable "helm_values_file" {
  description = "Path to Helm values file inside GitOps repo"
  type        = string
}