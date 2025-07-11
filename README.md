# Task 5: Simple Application Deployment with Helm

### Introduction

All environment was set up in previous task.
Npm scripts have been created to automate environment management (`package.json`):

```
# Start environment
npm run start

# Start environment
npm run stop

# Environment status
npm run status
```

### Note for Windows PowerShell

Since Docker Desktop and Kubernetes require elevated privileges, the easiest option is to use PowerShell with administrator rights.

Setting permission for PowerShell to execute scripts:

```
# Allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Revoke permission (return to safe state)
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser

# Check current policy
Get-ExecutionPolicy -List
```

## Deployment with Helm 

- Copied app from [flask_app](https://github.com/rolling-scopes-school/tasks/tree/master/devops/flask_app) to folder `app`
- Created `Dockerfile`
- Folder `helm/app` for Helm chart
- Created Helm chart:
```
helm create app
```

- Prepared values for Helm chart (`helm/app/values.yaml`)
- Created `build-and-deploy.ps1` to build and deploy app
- Added `deploy` script to `package.json` to execute `build-and-deploy.ps1`
- Execute
```
npm run deploy
```

### Deployment step-by-step

- Build the Docker image: `docker build -t flask-app:latest ./app`
- Load into Minikube: `minikube image load flask-app:latest`
- Deploy with Helm: `helm install app ./helm/app`
- Get the URL: `minikube service app --url`

