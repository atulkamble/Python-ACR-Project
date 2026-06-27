# 🚀 Deploying a Python Docker App using Azure Container Registry (ACR)

This guide demonstrates how to **build**, **push**, **pull**, and **run** a Dockerized Python application using **Azure Container Registry**, and finally deploy it on **Azure Container Instances**.

```
git clone https://github.com/atulkamble/Python-ACR-Project.git
cd Python-ACR-Project
```

---

## 📌 Prerequisites

* Azure account with an active subscription
* Azure CLI installed (`az`)
* Docker installed (with `buildx` enabled)
* A Python application with a `Dockerfile`
* Access to Azure Container Registry

---

## 🧱 Architecture Overview

```text
Local Machine
   │
   │ docker buildx
   ▼
Azure Container Registry (ACR)
   │
   │ docker pull
   ▼
Another Machine / Azure Container Instance
   │
   ▼
Python App running on Port 5000
```

---

## 🏷️ Registry Details

* **Registry Name:** `atulkamble.azurecr.io`
* **Image Name:** `cloudnautic/basic-python-app`
* **Tag:** `latest`

---

## 🔐 Step 1: Login to Azure Container Registry

Authenticate Docker with your ACR:

```bash
az acr login --name atulkamble
```
OR 
```
docker login -u atuljkamble
```

✅ This allows Docker to push/pull images securely.

---

## 🛠️ Step 2: Build Docker Image (Multi-Platform)

### 🔹 Option 1: Standard Build

```bash
sudo docker buildx build --platform linux/amd64,linux/arm64 -t docker.io/atuljkamble/pythonapp:latest --load .
```
OR
```bash
sudo docker buildx build --platform linux/amd64,linux/arm64 -t atulkamble.azurecr.io/cloudnautic/basic-python-app:latest --load .
```

---

### 🔹 Option 2: Explicit Linux Build (Recommended)

Use this when building on macOS (Apple Silicon) or mixed architectures:

```bash
sudo docker buildx build --platform linux/arm64/v8 -t atulkamble.azurecr.io/cloudnautic/basic-python-app:latest --load .
```

### Docker Practice 
```
docker images
docker push docker.io/atuljkamble/pythonapp:latest  
docker images
docker rmi -f atuljkamble/pythonapp:latest
docker pull atuljkamble/pythonapp:latest
docker images 
docker run -d -p 5000:5000 atuljkamble/pythonapp:latest
// http://localhost:5000
docker container ls
docker container stop e0f3d3307f5a
docker container ls               
docker ps -a
docker container start e0f3d3307f5a
docker container ls
```

---

## 📦 Step 3: Verify Docker Image

```bash
sudo docker images
```

✔️ Confirm the image appears with `atulkamble.azurecr.io/...`

---

## ☁️ Step 4: Push Image to Azure Container Registry

```bash
sudo docker push atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

✅ Image is now securely stored in Azure ACR.

---

## 💻 Step 5: Pull Image on Another Machine

On any other VM / system with Docker:

```bash
sudo docker pull atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

Verify:

```bash
sudo docker images
```

---

## ▶️ Step 6: Run the Container

```bash
sudo docker run -d -p 5000:5000 \
  atulkamble.azurecr.io/cloudnautic/basic-python-app:latest
```

Check running containers:

```bash
sudo docker container ls
```

---

## 🌐 Step 7: Access the Application

Open browser:

```text
http://localhost:5000
```

🎉 Python app is now live!

---

## 🔑 Step 8: Enable ACR Admin Access (For ACI)

Azure Container Instances require registry credentials.

```bash
az acr update \
  -n atulkamble.azurecr.io \
  --admin-enabled true
```

⚠️ **Note:** Enable admin only for demos/labs. Use managed identity in production.

---

## 🚢 Step 9: Deploy Image to Azure Container Instances (ACI)

From **Azure Portal**:

1. Open **Azure Container Registry**
2. Select **Repositories**
3. Choose `cloudnautic/basic-python-app`
4. Click **Create → Container Instance**
5. Configure:

   * Port: `5000`
   * Public IP: Enabled
   * OS: Linux

Once deployed, Azure provides a public IP.

---

## 🌍 Step 10: Access App via Public IP

```text
http://20.204.208.81:5000/
```

✅ Application is now running on Azure without any VM!

##  Step 11: Deploy to Kubernetes
```
az aks create --resource-group devops --name mycluster --node-count 2 --enable-managed-identity --generate-ssh-keys
az aks get-credentials --resource-group devops --name mycluster --overwrite-existing
kubectl get nodes 
kubectl apply -f aks-deployment.yaml
kubectl apply -f aks-service.yaml
kubectl get pods
kubectl get service
```
## 🌍 Step 12: Access App via K8s Service

```
http://20.29.163.101/
```
## Delete Resource Group 
```
az group delete -n devops
```

---

## 🧠 Best Practices

* Use `linux/amd64` for maximum compatibility
* Avoid ACR admin in production
* Prefer **Managed Identity** with ACI
* Version images using tags (`v1`, `v2`)
* Use private endpoints for enterprise security

---
