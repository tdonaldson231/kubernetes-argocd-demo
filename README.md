# ArgoCD, Helm, Terraform Demo

This project demonstrates how to use Terraform to configure an [ArgoCD](https://argo-cd.readthedocs.io/) Application that deploys an NGINX Helm chart into `dev` and `uat` namespaces on a Kubernetes cluster.

ArgoCD has been set up to automatically deploy apps to the test namespaces when an update is detected in the monitoring repository.

## Prerequisites

- [DockerDesktop](https://docs.docker.com/desktop/setup/install/windows-install/)
    - Kubernetes enabled (kind cluster method with two nodes)
- [Terraform](https://www.terraform.io/downloads)
- [Helm](https://helm.sh/docs/intro/quickstart/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) 

## Setup

### 1. Clone this repository

```bash
git clone https://github.com/tdonaldson231/kubernetes-argocd-demo.git
cd kubernetes-argocd-demo/terraform-argocd-apps
```

### 2. Setup ArgoCD and Access UI

Once you have Helm ready, you can add the ArgoCD chart repository.
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd --create-namespace
```
It takes about a minute for all Pods to initialize.
```bash
$ kubectl get pods -n argocd
NAME                                               READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                    1/1     Running   0          84s
argocd-applicationset-controller-76f656df8-vdwt6   1/1     Running   0          85s
argocd-dex-server-5d8f958d7b-vgnmp                 1/1     Running   0          84s
argocd-notifications-controller-8649cfc95d-vnfc5   1/1     Running   0          84s
argocd-redis-54b74f4bf8-qc4z8                      1/1     Running   0          84s
argocd-repo-server-868d6c499b-wnrmp                1/1     Running   0          84s
argocd-server-748bb6bd64-n4nlj                     1/1     Running   0          84s
```
Expose the ArgoCD server service and enable port-forwarding:
```bash
kubectl expose service argocd-server --type=NodePort --name=argocd-server-nodeport -n argocd --port=80 --target-port=9090
kubectl port-forward svc/argocd-server -n argocd 9090:443
```

### 3. Create namespaces on Kubernetes cluster

To simulate different test environments, create the following namespaces:
```bash
$ kubectl create namespace dev
$ kubectl create namespace uat
```

### 4. Setup ArgoCD Apps using Terraform

From the terminal, navigate to the `terraform-argocd-apps` directory.
Select the `dev` workspace first:

```bash
$ terraform workspace select dev
Switched to workspace "dev".
```

Then Initialize, Plan, and Apply Terraform

```bash
terraform init
terraform plan -out out.tfplan  ##verify output
terraform apply out.tfplan
```

### 5. Access ArgoCD to view Apps

Login to ArgoCD to view `nginx-helm-chart-dev` App Health/Sync Status
- ArgoCD UI should be accessible: `https://127.0.0.1:9090/`\
- Username: `admin`
- Password (run this command to retrieve): 
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### NOTE: charts exist for a uat namespace also