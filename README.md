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

* Create new container with Helm and kubectl

Dockerfile — `Jenkins/Dockerfile`

```
docker build -t evgeneys/jenkins-with-tools:latest .
docker push evgeneys/jenkins-with-tools:latest
```

Updated Helm chart values

```
# update jenkins
helm upgrade --install jenkins ./jenkins-chart -n jenkins

# check status
kubectl get pods -n jenkins
```

* Set port forwarding:
```
start cmd /k "kubectl port-forward svc/jenkins 8080:8080 -n jenkins"
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

## Installing the other required components into the Jenkins container

* Log in to Jenkins pod
```
kubectl exec -n jenkins -it jenkins-0 -- bash
```

* Helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

* kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

* Kaniko

