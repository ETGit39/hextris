variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "hextris-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the cluster"
  type        = string
  default     = "v1.28.0"
}