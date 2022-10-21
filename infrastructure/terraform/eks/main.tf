locals {
  name            = "Gatewise"
  cluster_version = "1.23"
  cluster_kms_arn = "arn:aws:kms:us-east-1:734061930556:key/1a119d2a-dd66-4097-892c-762a0771f7d7"
}

data "aws_vpcs" "selected" {
  tags = {
    Name = var.vpc_name
    env  = var.env
  }
}
data "aws_subnets" "lhtran_public" {
  tags = {
    Name = "*public*"
    env  = var.env
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.selected.ids[0]]
  }
  filter {
    name   = "tag:kubernetes.io/role/elb"
    values = ["1"]
  }
}
data "aws_subnets" "lhtran_private" {
  tags = {
    Name = "*private*"
    env  = var.env
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.selected.ids[0]]
  }
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}
data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.selected.ids[0]]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.30"

  cluster_name    = local.name
  cluster_version = local.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = local.cluster_kms_arn
    resources        = ["secrets"]
  }]

  manage_aws_auth_configmap = true
  aws_auth_roles            = var.aws_auth_roles
  aws_auth_users            = var.aws_auth_users
  aws_auth_accounts         = var.aws_auth_accounts


  vpc_id                   = data.aws_vpcs.selected.ids[0]
  subnet_ids               = data.aws_subnets.lhtran_public.ids
  control_plane_subnet_ids = data.aws_subnets.lhtran_public.ids

  create_cluster_security_group         = false
  create_node_security_group            = false
  cluster_additional_security_group_ids = data.aws_security_groups.default.ids


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    use_name_prefix                       = true
    vpc_security_group_ids                = data.aws_security_groups.default.ids
    instance_types                        = var.nodegroup_instance_type
    attach_cluster_primary_security_group = true
    create_security_group                 = false
    iam_role_attach_cni_policy            = true
    ebs_optimized                         = true
    disable_api_termination               = true
    enable_monitoring                     = false
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = var.nodegroup_vol_size
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }
  eks_managed_node_groups = {

    default_nodegroup = {
      name = var.nodegroup_name

      subnet_ids = data.aws_subnets.lhtran_public.ids

      min_size     = 1
      max_size     = 4
      desired_size = 1

      # capacity_type        = "SPOT"
      force_update_version = true
      instance_types       = var.nodegroup_instance_type

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }
}

module "aws_lb_ctrl_iam" {
  source                = "./aws-lb-ctrl-iam"
  eks_oidc_provider     = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
}


