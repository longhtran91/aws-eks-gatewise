module "gatewise_eks" {
  source                  = "./eks"
  vpc_name                = var.vpc_name
  env                     = var.env
  nodegroup_name          = var.nodegroup_name
  nodegroup_instance_type = var.nodegroup_instance_type
  nodegroup_vol_size      = var.nodegroup_vol_size
  aws_auth_roles          = var.eks_aws_auth_roles
  aws_auth_users          = var.eks_aws_auth_users
  aws_auth_accounts       = var.eks_aws_auth_accounts
}

module "gatewise_kubernetes" {
  depends_on = [
    module.gatewise_eks
  ]
  source                             = "./kubernetes"
  registry_name                      = var.registry_name
  registry_server                    = var.registry_server
  registry_username                  = var.registry_username
  registry_password                  = var.registry_password
  registry_email                     = var.registry_email
  aws_load_balancer_iam_role_arn     = module.gatewise_eks.aws_load_balancer_iam_role_arn
  cluster_endpoint                   = module.gatewise_eks.cluster_endpoint
  cluster_certificate_authority_data = module.gatewise_eks.cluster_certificate_authority_data
  cluster_id                         = module.gatewise_eks.cluster_id
}