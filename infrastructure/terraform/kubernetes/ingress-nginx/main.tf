resource "helm_release" "ingress_nginx_controller" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-attributes"
    value = "load_balancing.cross_zone.enabled=true"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }
  set {
    name  = "controller.ingressClassResource.default"
    value = "true"
  }
}