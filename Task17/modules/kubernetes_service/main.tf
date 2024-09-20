resource "kubernetes_service" "service" {
  metadata {
    name = var.service_name
  }

  spec {
    selector = var.match_labels

    port {
      port        = var.port
      target_port = var.target_port
    }

    type = var.service_type
  }
}
