#!/bin/bash

# Azure Container Registry Setup for Minikube
# This script helps configure Kubernetes to pull images from Azure Container Registry

echo "Setting up ACR authentication for Kubernetes..."

# Variables
ACR_NAME="atulkamble"
ACR_LOGIN_SERVER="atulkamble.azurecr.io"
IMAGE_NAME="cloudnautic/basic-python-app:latest"

# Pull the image locally (optional, for testing)
echo "Pulling image from ACR..."
sudo docker pull ${ACR_LOGIN_SERVER}/${IMAGE_NAME}

# Option 1: Create Kubernetes secret using Azure CLI (if logged in)
echo ""
echo "Creating Kubernetes secret for ACR..."
echo "Make sure you have Azure CLI installed and logged in (az login)"
echo ""

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name ${ACR_NAME} --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name ${ACR_NAME} --query "passwords[0].value" -o tsv)

# Create Kubernetes secret
kubectl create secret docker-registry acr-secret \
  --docker-server=${ACR_LOGIN_SERVER} \
  --docker-username=${ACR_USERNAME} \
  --docker-password=${ACR_PASSWORD} \
  --docker-email=your-email@example.com

# Option 2: If you already have the credentials, create secret manually
# kubectl create secret docker-registry acr-secret \
#   --docker-server=atulkamble.azurecr.io \
#   --docker-username=<your-username> \
#   --docker-password=<your-password> \
#   --docker-email=<your-email>

echo ""
echo "ACR secret created successfully!"
echo "You can now deploy the application using:"
echo "kubectl apply -f deployment.yaml"
echo "kubectl apply -f service.yaml"
