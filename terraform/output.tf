output "cluster_name" {
  description = "Name of the created Kind cluster"
  value       = kind_cluster.hextris_cluster.name
}

output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = kind_cluster.hextris_cluster.endpoint
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = kind_cluster.hextris_cluster.kubeconfig_path
}
