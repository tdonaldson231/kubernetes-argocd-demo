
variable "argocd_server_addr" {
  description = "ArgoCD server:port"
  type = string
  default = "localhost:9090"
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

variable "branch_name" {
  description = "ArgoCD target_revision (branch)"
  default = "main" ##helm-charts-nginx  
}