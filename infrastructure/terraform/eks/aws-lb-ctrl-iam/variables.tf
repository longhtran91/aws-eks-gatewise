variable "eks_oidc_provider" {
  type        = string
  description = "EKS OIDC url without https://"
}
variable "eks_oidc_provider_arn" {
  type        = string
  description = "IAM EKS OIDC provider arn"
}