Write-Host "Stopping Minikube..." -ForegroundColor Yellow
minikube stop

Write-Host "Stopping Docker Desktop..." -ForegroundColor Yellow
Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue

Write-Host "Environment stopped!" -ForegroundColor Green
