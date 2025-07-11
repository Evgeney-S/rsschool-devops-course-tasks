Write-Host "=== Docker Status ===" -ForegroundColor Cyan
docker --version
docker ps

Write-Host "`n=== Minikube Status ===" -ForegroundColor Cyan
minikube status

Write-Host "`n=== Kubernetes Status ===" -ForegroundColor Cyan
kubectl cluster-info
kubectl get nodes
