Write-Host "Building Docker image..." -ForegroundColor Green
docker build -t flask-app:latest ./app

Write-Host "Loading image to Minikube..." -ForegroundColor Green
minikube image load flask-app:latest

Write-Host "Deploying with Helm..." -ForegroundColor Green
helm upgrade --install app ./helm/app

Write-Host "Waiting for pods to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=app --timeout=300s

Write-Host "Getting service URL..." -ForegroundColor Green
Start-Sleep -Seconds 5

# Запускаем команду с таймаутом
$job = Start-Job -ScriptBlock { minikube service app --url }
if (Wait-Job $job -Timeout 10) {
    $url = Receive-Job $job
    Write-Host "Application URL: $url" -ForegroundColor Cyan
} else {
    Write-Host "Timeout getting URL. Try manually: minikube service app --url" -ForegroundColor Yellow
}
Remove-Job $job -Force

Write-Host "Deployment complete!" -ForegroundColor Green
