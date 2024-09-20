output "deployment_name" {
  description = "The name of the deployment"
  value       = kubernetes_deployment.deployment.metadata[0].name
}
