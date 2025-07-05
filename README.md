# RS School DevOps course

## Task 4: Jenkins Installation and Configuration

### 

- Install Minikube

```
choco install minikube

# check
minikube version

# Start your cluster
minikube start

# check
kubectl get all
```

- Install Helm

```
choco install kubernetes-helm

# check
helm version
helm list
```

- Deploying the Nginx chart from Bitnami

```
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx

# check
helm list
kubectl get all --all-namespaces
```

## Jenkins Helm Chart

This Helm chart deploys Jenkins with Configuration as Code (JCasC) on Kubernetes.

### Features

- Jenkins with JCasC configuration
- Persistent volume for Jenkins data
- Pre-configured authentication and security
- Automatically created "Hello World" job via JCasC
- Job DSL plugin included

### Installation

1. Add Jenkins Helm repository:
```
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

2. Install the chart:
```
helm dependency update jenkins-chart/
helm install jenkins jenkins-chart/ --namespace jenkins --create-namespace
```

3. Access Jenkins:
```
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
```

4. Login credentials:
- Username: `admin`
- Password: `admin123`

### Configuration

The chart includes:
- JCasC security configuration
- Persistent volume (8Gi)
- Job DSL plugin
- Pre-configured "hello-world" job

### Uninstall

```
helm uninstall jenkins --namespace jenkins
```


### GitHub Actions (GHA) Pipeline (5 points)
- A GHA pipeline is set up to deploy Jenkins.

Automatically applied for local installation, as it was told on the lecture.
