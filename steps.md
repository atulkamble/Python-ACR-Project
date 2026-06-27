git clone https://github.com/atulkamble/Python-ACR-Project
cd Python-ACR-Project

// docker desktop running
docker login -u atuljkamble
git --version
git clone https://github.com/atulkamble/Python-ACR-Project\ncd Python-ACR-Project
code .
docker buildx build --platform linux/amd64,linux/arm64 -t docker.io/atuljkamble/pythonapp:latest --load .
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

az aks create --resource-group devops --name mycluster --node-count 2 --enable-managed-identity --generate-ssh-keys

az aks get-credentials --resource-group devops --name mycluster --overwrite-existing

kubectl get nodes 

kubectl apply -f aks-deployment.yaml
kubectl apply -f aks-service.yaml

kubectl get pods
kubectl get service 

http://20.29.163.101/

az group delete -n devops


