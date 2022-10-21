resource "aws_iam_policy" "aws_load_balancer" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/eks-oidc-policy.json")
}

resource "aws_iam_role" "aws_load_balancer" {
  name = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = templatefile("${path.module}/eks-oidc-role.json", {
    eks_oidc_provider = var.eks_oidc_provider
    eks_oidc_arn      = var.eks_oidc_provider_arn
  })
  managed_policy_arns = [aws_iam_policy.aws_load_balancer.arn]
}

