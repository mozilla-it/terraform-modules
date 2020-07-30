output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "worker_asg_names" {
  value = module.eks.workers_asg_names
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "node_groups" {
  value = module.eks.node_groups
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}
