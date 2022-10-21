resource "kubernetes_deployment_v1" "gatewise" {
  depends_on = [
    kubernetes_secret_v1.gatewise_web
  ]
  metadata {
    name = "gatewise"
    labels = {
      app = "gatewise"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "gatewise"
      }
    }

    template {
      metadata {
        labels = {
          app = "gatewise"
        }
      }

      spec {
        image_pull_secrets {
          name = var.registry_name
        }
        container {
          image = "longhtran91/gatewise-web"
          name  = "gatewise"

          env_from {
            secret_ref {
              name = "gatewise-web"
            }
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "gatewise_svc" {
  metadata {
    name      = "gatewise-svc"
    namespace = "default"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = "80"
      target_port = "8000"
    }

    selector = {
      app = "gatewise"
    }
  }
}

