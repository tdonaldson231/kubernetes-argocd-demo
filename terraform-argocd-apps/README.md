# Terraform ArgoCD App Deployment

This project demonstrates how to use Terraform to configure an [ArgoCD](https://argo-cd.readthedocs.io/) Application that deploys an NGINX Helm chart into `dev` and `uat` namespaces on a Minikube Kubernetes cluster.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) running a Kubernetes cluster  
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)  
- [Terraform](https://www.terraform.io/downloads)  
- ArgoCD installed on your Minikube cluster  
- Your local kubeconfig context pointing to Minikube  

## Setup

### 1. Clone this repository

```bash
git clone https://github.com/tdonaldson231/kubernetes-argocd-demo.git
cd kubernetes-argocd-demo/terraform-argocd-apps
```

### 2. Select the `dev` workspace

```bash
$ terraform workspace select dev
Switched to workspace "dev".
```

### 3. Initialize and Plan Terraform

```bash
terraform init
terraform plan -out out.tfplan
```

### 4. Apply the Terraform plan

```bash
terraform apply out.tfplan
```

### 5. Inspect the deployed resources:

```bash
kubectl get all -n dev
```

#### NOTE: charts exist for a uat namespace also