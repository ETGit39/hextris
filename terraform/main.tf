resource "kind_cluster" "hextris_cluster" {
  name            = var.cluster_name
  node_image      = "kindest/node:${var.kubernetes_version}"
  kubeconfig_path = pathexpand("~/.kube/config")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"

      extra_port_mappings {
        container_port = 30080
        host_port      = 8080
        protocol       = "TCP"
      }
    }
  }
}
