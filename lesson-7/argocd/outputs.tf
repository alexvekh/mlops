output "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argo.metadata[0].name
}

output "argocd_release_name" {
  value = helm_release.argo.name
}

output "argocd_server_service" {
  description = "Service name of argocd-server"
  value       = "argocd-server"
}
