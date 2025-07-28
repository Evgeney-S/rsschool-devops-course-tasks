# Monitoring Stack Deployment (Prometheus + Grafana)

This monitoring setup includes Prometheus and Grafana installed into a Kubernetes cluster using Helm and Jenkins pipeline.

## Environment

- Local setup in Windows OS using PowerShell to manage it
- Docker Desktop
- Minikube running in Docker container
- Jenkins installed via Helm
```
# jenkins port-forward
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
```

## Deployment Steps

1. Build Jenkins agent:

    - Docker image for Jenkins agent: `monitoring/jenkins/Dockerfile`

   ```bash
   docker build -t evgeneys/helm-kubectl-agent:latest -f Dockerfile .
   docker push evgeneys/helm-kubectl-agent:latest
   ```

2. Create all YAML files in Git repository: 
    - `monitoring/jenkins/monitoring-agent.yaml`
    - `monitoring/helm/prometheus-values.yaml`
    - `monitoring/helm/grafana-values.yaml`
    - `monitoring/helm/grafana-provisioning` - separate Helm chart to create config maps for provisioning alerts, contact point and policies
    - `monitoring/helm/grafana-provisioning/teplates/provisioning-configmap.yaml`
    - `monitoring/helm/grafana-provisioning/chart.yaml`
    - `monitoring/helm/grafana-provisioning/values.yaml`

3. Create pipeline in Jenkins using `monitoring/Jenkinsfile`
4. Run pipeline in Jenkins
5. After deployment, forward Grafana port:
```
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```
6. Access Grafana at: http://localhost:3000

## Alert Rules

- High CPU usage (>80%) on a node

- Low available memory (<20%) on a node


## Email Alerts

- Configured to use SMTP at smtp.mailtrap.io:2525

- Customize the address in smtp-contact.yaml


## To simulate alerts

```
# CPU
kubectl -n monitoring run cpu-stress --image=ubuntu --restart=Never -- bash -c "apt-get update && apt-get install -y stress && stress --cpu 2"

# Memory
kubectl -n monitoring run mem-stress --image=ubuntu --restart=Never -- bash -c "apt-get update && apt-get install -y stress && stress --vm 4 --vm-bytes 512M"
```

* Remove test pods
```
kubectl delete pod cpu-stress -n monitoring
kubectl delete pod mem-stress -n monitoring
```
