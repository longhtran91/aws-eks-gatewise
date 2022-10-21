variable "vpc_name" {
  type        = string
  default     = "lhtran-core-vpc"
  description = "VPC id to deploy Gatewise"
}
variable "env" {
  type        = string
  default     = "development"
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
variable "aws_auth_roles" {
  type        = list(any)
  default     = []
  description = "IAM role arn to authenticate to the cluster"
}
variable "aws_auth_users" {
  type        = list(any)
  default     = []
  description = "IAM user arn to authenticate to the cluster"
}
variable "aws_auth_accounts" {
  type        = list(any)
  default     = []
  description = "AWS account to authenticate to the cluster"
}