variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "lesson-8-9-eks"
}

variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "terraform-state-bucket-dk-lesson-8-9"
}

variable "table_name" {
  description = "DynamoDB table name for Terraform locks"
  type        = string
  default     = "terraform-locks-lesson-8-9"
}

variable "ecr_name" {
  description = "ECR repository name"
  type        = string
  default     = "lesson-8-9-ecr"
}

variable "git_branch" {
  description = "Git branch used by Jenkins and Argo CD"
  type        = string
  default     = "main"
}

variable "app_repo_url" {
  description = "Repository URL containing the lesson-8-9 project folder"
  type        = string
}

variable "gitops_repo_url" {
  description = "Repository URL monitored by Argo CD"
  type        = string
}

variable "github_username" {
  description = "Git username for Jenkins commits"
  type        = string
}

variable "github_email" {
  description = "Git email for Jenkins commits"
  type        = string
}

variable "github_token" {
  description = "GitHub token used by Jenkins to clone and push"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWS access key used by Jenkins Kaniko build"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key used by Jenkins Kaniko build"
  type        = string
  sensitive   = true
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "django_namespace" {
  description = "Namespace where Django app will be deployed"
  type        = string
  default     = "django"
}

variable "jenkins_admin_username" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "jenkins_chart_version" {
  description = "Version of Jenkins Helm chart"
  type        = string
  default     = "5.8.110"
}

variable "argocd_chart_version" {
  description = "Version of Argo CD Helm chart"
  type        = string
  default     = "7.7.16"
}