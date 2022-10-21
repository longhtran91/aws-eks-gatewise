variable "registry_name" {
  type        = string
  description = "Registry name"
}
variable "registry_server" {
  type        = string
  default     = "docker.io"
  description = "Registry server"
}
variable "registry_username" {
  type        = string
  description = "Username to login to registry server"
}
variable "registry_password" {
  type        = string
  description = "Password to login to registry server"
}
variable "registry_email" {
  type        = string
  description = "Password to login to registry server"
}
variable "aws_load_balancer_iam_role_arn" {
  type        = string
  description = "AWS load balancer iam role arn"
}
variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}
variable "cluster_certificate_authority_data" {
  type        = string
  description = "EKS cluster CA cert"
}
variable "cluster_id" {
  type        = string
  description = "EKS cluster id "
}