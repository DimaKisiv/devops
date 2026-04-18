provider "aws" {
  region = var.aws_region
}

locals {
  django_chart_path = "lesson-8-9/charts/django-app"
  django_values_file = "lesson-8-9/charts/django-app/values.yaml"
  app_context_path  = "lesson-8-9/django"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.bucket_name
  table_name  = var.table_name
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  vpc_name           = "lesson-8-9-vpc"
  eks_cluster_name   = var.cluster_name
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = true
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.cluster_name
  cluster_version     = "1.30"
  cluster_subnet_ids  = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  node_subnet_ids     = module.vpc.private_subnets
  node_group_name     = "lesson-8-9-workers"
  node_instance_types = ["t3.medium"]
  desired_size        = 2
  min_size            = 2
  max_size            = 3
}

module "jenkins" {
  source                = "./modules/jenkins"
  cluster_name          = module.eks.cluster_name
  aws_region            = var.aws_region
  namespace             = var.jenkins_namespace
  chart_version         = var.jenkins_chart_version
  admin_username        = var.jenkins_admin_username
  admin_password        = var.jenkins_admin_password
  github_username       = var.github_username
  github_email          = var.github_email
  github_token          = var.github_token
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  app_repo_url          = var.app_repo_url
  gitops_repo_url       = var.gitops_repo_url
  git_branch            = var.git_branch
  ecr_repository_url    = module.ecr.repository_url
  app_context_path      = local.app_context_path
  helm_values_file      = local.django_values_file
}

module "argo_cd" {
  source            = "./modules/argo_cd"
  cluster_name      = module.eks.cluster_name
  aws_region        = var.aws_region
  namespace         = var.argocd_namespace
  chart_version     = var.argocd_chart_version
  gitops_repo_url   = var.gitops_repo_url
  git_branch        = var.git_branch
  applications = [
    {
      name                  = "django-app"
      project               = "default"
      namespace             = var.django_namespace
      repo_url              = var.gitops_repo_url
      path                  = local.django_chart_path
      target_revision       = var.git_branch
      destination_server    = "https://kubernetes.default.svc"
      automated             = true
      prune                 = true
      self_heal             = true
      create_namespace      = true
    }
  ]
}