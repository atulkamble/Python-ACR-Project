# 🚀 Deploying a Python Docker Application

## 🐳 Azure Container Registry (ACR)

## 📦 Azure Container Instances (ACI)

## ☸️ Azure Kubernetes Service (AKS)

# Lab Overview

In this lab, you will learn how to:

* Build a Docker image
* Push the image to Azure Container Registry (ACR)
* Pull the image from ACR
* Run the application locally using Docker
* Deploy the application to Azure Container Instances (ACI)
* Deploy the application to Azure Kubernetes Service (AKS)
* Verify application accessibility
* Clean up Azure resources

---

# Learning Objectives

After completing this lab, you will be able to:

* Understand Azure Container Registry
* Build Docker images for Linux
* Push and pull images securely
* Run containers locally
* Deploy containers without virtual machines
* Deploy applications on Kubernetes
* Understand the complete container deployment lifecycle

---

# Prerequisites

Software

* Azure CLI
* Docker Desktop
* Docker Buildx
* kubectl
* Git

Azure Resources

* Azure Subscription
* Azure Container Registry
* Resource Group
* Azure Kubernetes Service (AKS)

Knowledge Required

* Basic Docker
* Basic Azure
* Basic Kubernetes
* Basic Linux Commands

---

# Project Repository

```bash
git clone https://github.com/atulkamble/Python-ACR-Project.git

cd Python-ACR-Project
```

---

# Project Architecture

```text
                    Developer Machine
                           │
          Git Clone Project Repository
                           │
                           ▼
                 Docker Build Image
                           │
                           ▼
          Azure Container Registry (ACR)
                           │
          ┌────────────────┴───────────────┐
          │                                │
          ▼                                ▼
Azure Container Instance (ACI)     Azure Kubernetes Service (AKS)
          │                                │
          ▼                                ▼
      Public IP                      LoadBalancer IP
          │                                │
          └───────────────┬────────────────┘
                          ▼
                    End Users
```

---

# Deployment Workflow

```text
GitHub

↓

Docker Build

↓

Docker Image

↓

Azure Container Registry

↓

Azure Container Instance

OR

Azure Kubernetes Service

↓

Public IP

↓

Browser
```

---

# Azure Resources Used

| Resource                 | Purpose                 |
| ------------------------ | ----------------------- |
| Resource Group           | Container Resources     |
| Azure Container Registry | Store Docker Images     |
| Azure Container Instance | Run Containers          |
| Azure Kubernetes Service | Container Orchestration |
| Public IP                | Application Access      |

---

# Registry Details

```
Registry Name

atulkamble.azurecr.io

Repository

cloudnautic/basic-python-app

Tag

latest
```

---

# Step 1 Login to Azure

```bash
az login
```

Verify

```bash
az account show
```

---

# Step 2 Login to Azure Container Registry

```bash
az acr login --name atulkamble
```

OR

```bash
docker login atulkamble.azurecr.io
```

Username

```
atuljkamble
```

Password

```
<ACR Password>
```

Retrieve credentials:

```bash
az acr credential show \
--name atulkamble
```

---

# Step 3 Build Docker Image

## Option 1 Multi Platform

```bash
docker buildx build \
--platform linux/amd64,linux/arm64 \
-t atulkamble.azurecr.io/cloudnautic/basic-python-app:latest \
--load .
```

---

## Option 2 AMD64 Only (Recommended for AKS)

```bash
docker buildx build \
--platform linux/amd64 \
-t atulkamble.azurecr.io/cloudnautic/basic-python-app:latest \
--load .
```

**Note:** Prefer `linux/amd64` for Azure Kubernetes Service node compatibility. Building only `linux/arm64` can cause image pull failures on AMD64 AKS node pools.

---

# Step 4 Verify Image

```bash
docker images
```

Expected

```
atulkamble.azurecr.io/cloudnautic/basic-python-app
latest
```

---

# Step 5 Push Image

```bash
docker push \
atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

---

# Step 6 Verify Repository

Portal

```
Azure Portal

↓

Container Registry

↓

Repositories

↓

cloudnautic/basic-python-app

↓

latest
```

---

# Docker Practice Commands

```bash
docker images

docker push docker.io/atuljkamble/pythonapp:latest

docker rmi -f atuljkamble/pythonapp:latest

docker pull atuljkamble/pythonapp:latest

docker images

docker run -d -p 5000:5000 atuljkamble/pythonapp:latest

docker ps

docker container ls

docker container stop <container-id>

docker container start <container-id>

docker logs <container-id>

docker exec -it <container-id> bash

docker inspect <container-id>

docker rm -f <container-id>
```

---

# Step 7 Pull Image on Another Machine

```bash
docker pull \
atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

Verify

```bash
docker images
```

---

# Step 8 Run Container

```bash
docker run -d \
-p 5000:5000 \
--name pythonapp \
atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

Verify

```bash
docker ps
```

---

# Step 9 Test Application

Local Browser

```
http://localhost:5000
```

---

# Step 10 Enable ACR Admin

```bash
az acr update \
-n atulkamble \
--admin-enabled true
```

Verify

```bash
az acr credential show \
--name atulkamble
```

---

# Step 11 Deploy to Azure Container Instances

Azure Portal

```
Azure Container Registry

↓

Repositories

↓

cloudnautic/basic-python-app

↓

Create

↓

Container Instance
```

Configuration

| Setting   | Value    |
| --------- | -------- |
| OS        | Linux    |
| CPU       | 1        |
| Memory    | 1.5 GB   |
| Port      | 5000     |
| Public IP | Enabled  |
| DNS Label | Optional |

---

# Step 12 Test ACI

```
http://<ACI-Public-IP>:5000
```

---

# Step 13 Create AKS Cluster

```bash
az group create \
-n devops \
-l centralindia
```

```bash
az aks create \
--resource-group devops \
--name mycluster \
--node-count 2 \
--enable-managed-identity \
--generate-ssh-keys
```

---

# Step 14 Connect to AKS

```bash
az aks get-credentials \
--resource-group devops \
--name mycluster \
--overwrite-existing
```

Verify

```bash
kubectl get nodes
```

---

# Step 15 Deploy Application

```bash
kubectl apply -f aks-deployment.yaml
```

```bash
kubectl apply -f aks-service.yaml
```

---

# Step 16 Verify Deployment

```bash
kubectl get pods

kubectl get deployments

kubectl get svc

kubectl get nodes
```

Describe pod

```bash
kubectl describe pod <pod-name>
```

Logs

```bash
kubectl logs <pod-name>
```

---

# Step 17 Access AKS Application

```
http://<LoadBalancer-IP>
```

Example

```
http://20.29.163.101/
```

---

# Step 18 Cleanup

Delete AKS resources

```bash
az group delete \
-n devops
```

Delete Docker images

```bash
docker image prune -a
```

---

# Common Docker Commands

```bash
docker images

docker ps

docker ps -a

docker logs

docker exec

docker inspect

docker stop

docker start

docker restart

docker rm

docker rmi

docker system prune -a
```

---

# Common Kubernetes Commands

```bash
kubectl get nodes

kubectl get pods

kubectl get svc

kubectl describe pod

kubectl logs

kubectl exec -it

kubectl delete deployment

kubectl delete service

kubectl delete pod
```

---

# Troubleshooting

| Problem             | Solution                                                         |
| ------------------- | ---------------------------------------------------------------- |
| ImagePullBackOff    | Verify image exists in ACR and AKS has permission to pull        |
| ErrImagePull        | Check image name, tag, and platform (`linux/amd64`)              |
| ContainerCreating   | Wait for image download or inspect pod events                    |
| CrashLoopBackOff    | Check application logs using `kubectl logs`                      |
| Port not accessible | Verify Docker port mapping, Service type, and NSG/firewall rules |
| Unauthorized        | Re-run `az acr login` or configure AKS with ACR access           |

---

# Best Practices

* Use `linux/amd64` images for Azure workloads unless targeting ARM nodes.
* Use semantic versioning (`v1.0`, `v1.1`) instead of relying only on `latest`.
* Prefer managed identities or AKS-ACR integration over ACR admin credentials in production.
* Scan container images for vulnerabilities before deployment.
* Keep images small by using lightweight base images and multi-stage builds.
* Store secrets in Azure Key Vault or Kubernetes Secrets, not inside Docker images.
* Use readiness and liveness probes for production Kubernetes deployments.
* Configure resource requests and limits for containers.
* Enable monitoring with Azure Monitor and Container Insights.

---

# Interview Questions

1. What is Azure Container Registry (ACR)?
2. Difference between Docker Hub and ACR.
3. Why use Buildx?
4. Difference between `linux/amd64` and `linux/arm64`.
5. Why do AKS deployments fail with `ImagePullBackOff`?
6. Difference between ACI and AKS.
7. What is the purpose of a Kubernetes Service?
8. Difference between `ClusterIP`, `NodePort`, and `LoadBalancer`.
9. Why should production environments avoid using the `latest` image tag?
10. How do you integrate AKS with ACR securely without enabling the ACR admin account?

This organization turns the guide into a complete training document suitable for students, lab practice, interviews, and corporate training sessions.
