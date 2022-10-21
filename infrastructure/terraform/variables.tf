variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region to deploy Gatewise"
  validation {
    condition     = contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2"], var.region)
    error_message = "Region must be in us-east-1, us-east-2, us-west-1, or us-west-2"
  }
}
variable "vpc_name" {
  type        = string
  default     = "lhtran-core-vpc"
  description = "VPC id to deploy Gatewise"
}
variable "env" {
  type        = string
  default     = "production"
  description = "Environment"
  validation {
    condition     = contains(["production", "development", "test"], var.env)
    error_message = "Environment must be production, development or test"
  }
}
variable "nodegroup_name" {
  type        = string
  default     = "Nodegroup-Gatewise"
  description = "Nodegroup name"
}
variable "nodegroup_instance_type" {
  type        = list(any)
  default     = ["t3.medium"]
  description = "Nodegroup instance type list"
}
variable "nodegroup_vol_size" {
  type        = number
  default     = 20
  description = "Nodegroup instance size"
}
variable "registry_name" {
  type        = string
  default     = "docker.io"
  description = "Registry name"
}
variable "registry_server" {
  type        = string
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
variable "eks_aws_auth_roles" {
  type        = list(any)
  default     = []
  description = "IAM role arn to authenticate to the cluster"
}
variable "eks_aws_auth_users" {
  type        = list(any)
  default     = []
  description = "IAM user arn to authenticate to the cluster"
}
variable "eks_aws_auth_accounts" {
  type        = list(any)
  default     = []
  description = "AWS account to authenticate to the cluster"
}