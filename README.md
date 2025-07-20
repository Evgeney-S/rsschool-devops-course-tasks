# Task 6: Application Deployment via Jenkins Pipeline

## Introduction

The environment was set up in previous task (task-4).

The environment was set up localy in Windows OS using PowerShell to manage it.

* Installed Docker Desktop
* Minikube running in Docker container
* Jenkins installed via Helm
* Check all environment
```
# check minikube status
minikube status

# check kubectl
kubectl get nodes

# check Jenkins
kubectl get all -n jenkins

# check helm list 
helm list -A

```

## Update Jenkins 

Jenkins was reinstalled, using official Helm chart Jenkins and custom file with values - `helm/jenkins/values.yaml`

```
# uninstall Jenkins
helm uninstall jenkins -n jenkins
kubectl delete namespace jenkins
kubectl get all -n jenkins
kubectl get ns

# install Jenkins
helm install jenkins jenkins/jenkins -n jenkins -f ./helm/jenkins/values.yaml
```

*  Installing other required components

```
# log in the Jenkins pod
kubectl exec -it jenkins-0 -n jenkins -- /bin/bash

# update packages and install curl and others
apt-get update && apt-get install -y curl wget unzip gnupg2 lsb-release

# install cubectl
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
kubectl version --client

# install Helm
HELM_VERSION="v3.14.4"
curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxvf "helm-${HELM_VERSION}-linux-amd64.tar.gz"
mv linux-amd64/helm /usr/local/bin/helm
helm version

```

* Install Kaniko
Created manifest `kaniko-sa.yaml`
Apply manifest:
```
kubectl apply -f kaniko-sa.yaml
```

* Set port forwarding:
```
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```
Now Jenkins UI can be opened in browser by adress:
[http://localhost:8080](http://localhost:8080)









## App

App name — `flas-app`
App modifications:
    - added function `health` and route `/health` for app verification
    - added simple function `add` and route `/add` for tests
    - added tests `test_main.py`


## SonarQube install

```
# add Helm repository
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

# create namespaces
kubectl create namespace sonarqube

```

* Created SonarQube config file `sonarqube-values.yaml`

```
# install SonarQube
helm upgrade --install sonarqube sonarqube/sonarqube \
  --namespace sonarqube \
  -f sonarqube-values.yaml

# check status
kubectl get pods -n sonarqube
kubectl get svc -n sonarqube

# get url

```

* Get URL
```
minikube service -n sonarqube sonarqube-sonarqube --url

# ❗  Because you are using a Docker driver on windows, the terminal needs to be open to run it.
```

### Add and configure SonarQube in Jenkins

* Install plugin `SonarQube Scanner` in Jenkins [Manage Jenkins → Plugins]
* Add SonarQube server [Manage Jenkins → Configure System]
* Install SonarScanner [Manage Jenkins → Global Tool Configuration]
* Can be used in Jenkins:
```
withSonarQubeEnv('SonarQube') {
    sh 'sonar-scanner -Dsonar.projectKey=flask-app -Dsonar.sources=flask-app'
}
```
