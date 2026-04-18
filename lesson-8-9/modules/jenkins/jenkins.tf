resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.chart_version
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  timeout          = 1200

  values = [
    templatefile("${path.module}/values.yaml", {
      namespace             = var.namespace
      admin_username        = var.admin_username
      admin_password        = var.admin_password
      github_username       = var.github_username
      github_email          = var.github_email
      github_token          = var.github_token
      aws_access_key_id     = var.aws_access_key_id
      aws_secret_access_key = var.aws_secret_access_key
      aws_region            = var.aws_region
      app_repo_url          = var.app_repo_url
      gitops_repo_url       = var.gitops_repo_url
      git_branch            = var.git_branch
      ecr_repository_url    = var.ecr_repository_url
      app_context_path      = var.app_context_path
      helm_values_file      = var.helm_values_file
    })
  ]

  depends_on = [kubernetes_namespace_v1.this]
}