resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  timeout          = 1200

  values = [
    templatefile("${path.module}/values.yaml", {
      namespace = var.namespace
    })
  ]

  depends_on = [kubernetes_namespace_v1.this]
}

resource "helm_release" "applications" {
  name             = "argocd-apps"
  chart            = "${path.module}/charts/argocd-apps"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      repositories = [
        {
          name = "gitops-repo"
          url  = var.gitops_repo_url
          type = "git"
        }
      ]
      applications = var.applications
    })
  ]

  depends_on = [helm_release.argocd]
}