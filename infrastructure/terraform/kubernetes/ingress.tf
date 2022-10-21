data "aws_ssm_parameter" "hostname" {
  name = "/gatewise/nginx/hostname-alt"
}

resource "kubernetes_ingress_v1" "lhtran_com" {
  wait_for_load_balancer = true
  metadata {
    name      = "lhtran.com"
    namespace = "default"
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["lhtran.com"]
      secret_name = "lhtran-tls"
    }

    rule {
      host = data.aws_ssm_parameter.hostname.value

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "gatewise-svc"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

data "aws_route53_zone" "selected" {
  name         = format("%s%s", regex("^(?:(?P<record>[^\\.]+))?(?:.(?P<domain>[^/?#]*))?", "${data.aws_ssm_parameter.hostname.value}").domain, ".")
  private_zone = false
}

resource "aws_route53_record" "gatewise" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = regex("^(?:(?P<record>[^\\.]+))?(?:.(?P<domain>[^/?#]*))?", "${data.aws_ssm_parameter.hostname.value}").record
  type    = "CNAME"
  ttl     = 300
  records = [kubernetes_ingress_v1.lhtran_com.status[0].load_balancer[0].ingress[0].hostname]
}


