
variable "argocd_server_addr" {
  description = "ArgoCD server:port"
  type = string
  default = "localhost:8080"
}

variable "argocd_username" {
  description = "ArgoCD username"
  type = string
  default = "admin"  
}

variable "argocd_password" {
  description = "ArgoCD password"
  type = string
}

# variable "kubes_environment" {
#   description = "Kubernetes cluster environment"
#   type        = string
# }
