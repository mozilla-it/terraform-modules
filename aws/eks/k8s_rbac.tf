resource "kubernetes_cluster_role_binding" "view-rolebinding" {
  count = local.cluster_features["k8s_rbac_view"] ? 1 : 0

  metadata {
    name = "view-access-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = "view-access-group"
    api_group = "rbac.authorization.k8s.io"
  }

}
