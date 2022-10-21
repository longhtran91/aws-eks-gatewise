output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "aws_load_balancer_iam_role_arn" {
  value = module.aws_lb_ctrl_iam.aws_load_balancer_iam_role_arn
}