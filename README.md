# Monitoring Stack Deployment (Prometheus + Grafana)

This monitoring setup includes Prometheus and Grafana installed into a Kubernetes cluster using Helm and Jenkins pipeline.

## Requirements

- Jenkins running with Kubernetes plugin
- Jenkins agent with `kubectl` and `helm`
- Minikube or any Kubernetes cluster
- Local SMTP server (Mailtrap or equivalent)

## Deployment Steps

1. Build Jenkins agent:

    - Docker image for Jenkins agent: `monitoring/jenkins/Dockerfile`

   ```bash
   docker build -t evgeneys/helm-kubectl-agent:latest -f monitoring-agent.Dockerfile .
   docker push evgeneys/helm-kubectl-agent:latest
   ```

2. Create all YAML files in Git repository: 
    - monitoring/jenkins/monitoring-agent.yaml
    - monitoring/helm/prometheus-values.yaml
    - monitoring/helm/grafana-values.yaml
    - monitoring/helm/grafana-admin-secret.yaml
    - monitoring/alerts/cpu-ram-alerts.yaml
    - monitoring/notifiers/smtp-contact.yaml

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
kubectl run -i --tty load-generator --rm --image=alpine -- sh
apk add stress
stress --cpu 2 --timeout 60
```

