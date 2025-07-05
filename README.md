# RS School DevOps course

## Task 4: Jenkins Installation and Configuration

### 

* Install Minikube

```
choco install minikube

# check
minikube version

# Start your cluster
minikube start

# check
kubectl get all
```

* Install Helm

```
choco install kubernetes-helm

# check
helm version
helm list
```

* Deploying and removing the Nginx chart from Bitnami

```
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx

# check
helm list
kubectl get all --all-namespaces
```

* Prepare the Cluster (managing persistent volumes (PV) and persistent volume claims (PVC))

File `scripts/test-pvc.yaml`

```
minikube addons enable default-storageclass
minikube addons enable storage-provisioner

kubectl apply -f test-pvc.yaml

# check result
kubectl get pvc
kubectl get pv
kubectl describe pvc test-pvc

# remove test PVC
kubectl delete -f test-pvc.yaml
```

### Intalling Jenkins

* Create namespace for Jenkins

```
kubectl create namespace jenkins
```

* Add Jenkins Helm repository

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

* Install Jenkins with persistent volume

```
helm install jenkins jenkins/jenkins --namespace jenkins --set persistence.enabled=true --set persistence.size=8Gi
```

* Get your 'admin' user password by running:
```
# bash
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

#PowerShell
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password; echo ""
```


* Set up browser access

```
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
```

* Login Jenkins:

    - http://localhost:8080
    - Username: admin
    - Password: (from previous step)

* Create freestyle project

    - New Item → Freestyle project → имя "hello-world"
    - Build Steps → Add build step → Execute shell
    - Add command: echo "Hello world"
    - Save → Build Now

* Delete Jenkins (to install using JCasC)

```
# delete pod
kubectl delete pod -n jenkins -l app.kubernetes.io/name=jenkins

# uninstall jenkins
helm uninstall jenkins --namespace jenkins
```

* Install Jenkins with JCasC configuration

File `jenkins-values.yaml`
```
helm install jenkins jenkins/jenkins --namespace jenkins -f jenkins-values.yaml

# set port-forward
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
```
