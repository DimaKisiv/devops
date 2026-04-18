variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "namespace" {
  description = "Argo CD namespace"
  type        = string
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
}

variable "gitops_repo_url" {
  description = "GitOps repository URL"
  type        = string
}

variable "git_branch" {
  description = "Git branch tracked by Argo CD"
  type        = string
}

variable "applications" {
  description = "Applications managed by Argo CD"
  type = list(object({
    name               = string
    project            = string
    namespace          = string
    repo_url           = string
    path               = string
    target_revision    = string
    destination_server = string
    automated          = bool
    prune              = bool
    self_heal          = bool
    create_namespace   = bool
  }))
}