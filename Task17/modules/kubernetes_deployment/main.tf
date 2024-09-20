resource "kubernetes_deployment" "deployment" {
  metadata {
    name = var.deployment_name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = var.match_labels
    }

    template {
      metadata {
        labels = var.match_labels
      }

      spec {
        container {
          image = var.container_image
          name  = var.container_name

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}
