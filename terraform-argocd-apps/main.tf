locals {
  environment = terraform.workspace
}

# Exposed ArgoCD API - authenticated using `username`/`password` (for now)
provider "argocd" {
  server_addr = var.argocd_server_addr
  username    = var.argocd_username
  password    = var.argocd_password
  insecure = true
}

# Helm application
resource "argocd_application" "helm" {
  metadata {
    name      = "nginx-helm-chart-${local.environment}"
    namespace = "argocd"
    labels = {
      env = local.environment
    }
    annotations = {
      "notifications.argoproj.io/subscribe.on-sync-succeeded" = "jenkins-e2e-webhook"
    }
  }

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "helm"
    }

    # Sync policy block
    sync_policy {
      automated {
        prune = true  # Optionally remove resources that are no longer in the manifest
        self_heal = true  # Optionally fix out-of-sync resources automatically
      }
    }

    source {
      repo_url        = "https://github.com/tdonaldson231/kubernetes-argocd-demo.git"
      path            = "nginx-helm-chart"
      target_revision = var.branch_name

      helm {
        release_name = "testing"
        ## Helm value overrides in Terraform. 
        ## They're equivalent to passing --set flags when you run a Helm install or upgrade
        # parameter {
        #   name  = "image.tag"
        #   value = "1.21.0"
        # }
        value_files = ["environments/${local.environment}/values.yaml"]
        ## adds extra values to the Helm release, as if you had something like this in your values.yaml
        # values = yamlencode({
        #   someparameter = {
        #     enabled   = true
        #     someArray = ["foo", "bar"]
        #   }
        # })
      }
    }
  }
}
