
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = local.cert_manager_namespace

    labels = {
      app = "cert-manager"
    }
  }
}

resource "aws_iam_policy" "cert_manager" {
  count       = var.cert_manager_enable_dns_challenge ? 1 : 0
  name_prefix = "${local.cert_manager_name_prefix}-policy-"
  path        = "/"
  description = "IAM Policy for cert-manager on ${var.cluster_id}"
  policy      = data.aws_iam_policy_document.cert_manager.json
}

module "cert_manager_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.20.0"
  create_role                   = var.cert_manager_enable_dns_challenge
  role_name                     = "${local.cert_manager_name_prefix}-role"
  provider_url                  = replace(local.cluster_oidc_issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.cert_manager.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.cert_manager_namespace}:cert-manager"]
  tags                          = merge({ Name = "${local.cert_manager_name_prefix}-role" }, local.cert_manager_tags)
}

# CRDs have to be installed differently, there is a drama about it in the community.
# TL;DR: Helm is not yet ready to upgrade CRDs and this can cause an outage.
# For more info read https://github.com/helm/helm/issues/7735
resource "null_resource" "cert_manager_crd" {
  provisioner "local-exec" {
    working_dir = path.module
    command     = <<EOF
for i in `seq 1 10`; do \
  echo $kube_config | base64 --decode > kube_config.yaml & \
  kubectl apply --validate=false -f ${local.cert_manager_crd_manifest} --kubeconfig kube_config.yaml && break ||
  sleep 10; \
done; \
rm kube_config.yaml;
EOF
    interpreter = var.null_resource_interpreter
    environment = {
      kube_config = base64encode(var.kubeconfig)
    }
  }

  triggers = {
    endpoint = data.aws_eks_cluster.this.endpoint
    version  = local.cert_manager_version
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = local.cert_manager_namespace
  version    = local.cert_manager_version

  dynamic "set" {
    iterator = item
    for_each = local.cert_manager_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
