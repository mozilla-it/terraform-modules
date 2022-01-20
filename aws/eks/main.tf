
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.eks.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "eks" {
  source                        = "terraform-aws-modules/eks/aws"
  create_eks                    = var.create_eks
  version                       = "~> 13, < 18.0.0"
  cluster_name                  = var.cluster_name
  cluster_version               = var.cluster_version
  cluster_enabled_log_types     = local.cluster_log_type
  cluster_log_retention_in_days = var.log_retention

  vpc_id  = var.vpc_id
  subnets = var.cluster_subnets

  node_groups          = var.node_groups
  node_groups_defaults = local.node_groups_defaults

  # non-managed worker nodes
  worker_groups                                      = var.worker_groups
  worker_additional_security_group_ids               = var.worker_additional_security_group_ids
  worker_create_cluster_primary_security_group_rules = var.worker_create_cluster_primary_security_group_rules
  worker_create_security_group                       = var.worker_create_security_group

  map_roles    = local.roles_expanded
  map_users    = var.map_users
  map_accounts = var.map_accounts

  manage_aws_auth  = true
  write_kubeconfig = false
  enable_irsa      = true
  kubeconfig_name  = var.cluster_name

  tags = local.tags
}
