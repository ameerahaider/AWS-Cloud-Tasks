output "service_name" {
  description = "The name of the service"
  value       = kubernetes_service.service.metadata[0].name
}
