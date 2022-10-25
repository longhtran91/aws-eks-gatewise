module "aws_lb_controller" {
  source                         = "./kube-system/aws-load-balancer-controller"
  aws_load_balancer_iam_role_arn = var.aws_load_balancer_iam_role_arn
  cluster_id                     = var.cluster_id
}

module "ingress_nginx_controller" {
  depends_on = [
    module.aws_lb_controller
  ]
  source = "./ingress-nginx"
}

module "gatewise" {
  depends_on = [
    module.ingress_nginx_controller
  ]
  source        = "./gatewise"
  registry_name = var.registry_name
}