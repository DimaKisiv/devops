resource "helm_release" "argo_cd" {
  name             = var.name
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml", {
      app_name             = var.app_name
      app_namespace        = var.app_namespace
      repo_url             = var.repo_url
      repo_target_revision = var.repo_target_revision
      app_path             = var.app_path
      repo_username        = var.repo_username
      repo_password        = var.repo_password
    })
  ]
}

resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false

  values = [
    templatefile("${path.module}/values.yaml", {
      app_name             = var.app_name
      app_namespace        = var.app_namespace
      repo_url             = var.repo_url
      repo_target_revision = var.repo_target_revision
      app_path             = var.app_path
      repo_username        = var.repo_username
      repo_password        = var.repo_password
    })
  ]

  depends_on = [helm_release.argo_cd]
}