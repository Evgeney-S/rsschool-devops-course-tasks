Write-Host "Starting Docker Desktop..." -ForegroundColor Green
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

Write-Host "Waiting for Docker to start..." -ForegroundColor Yellow
do {
    Start-Sleep -Seconds 5
    docker ps 2>$null
} while ($LASTEXITCODE -ne 0)

Write-Host "Docker is running!" -ForegroundColor Green

Write-Host "Starting Minikube..." -ForegroundColor Green
minikube start --driver=docker

Write-Host "Checking cluster status..." -ForegroundColor Green
kubectl cluster-info
kubectl get nodes

Write-Host "Environment is ready!" -ForegroundColor Green
