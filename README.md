# RS School DevOps course

## Task 3: K3s Kubernetes Cluster on AWS
This project deploys a K3s Kubernetes cluster on AWS using Terraform with proper network isolation and security.

### Architecture
- VPC: Custom VPC with 2 public and 2 private subnets across 2 AZs

- Bastion Host: Jump server in public subnet for secure access

- NAT Instance: Custom NAT instance for private subnet internet access

- K3s Master: Kubernetes control plane in private subnet

- K3s Worker: Kubernetes worker node in private subnet

- Security Groups: Properly configured for each component

### Deployment
1. Initialize Terraform
```
terraform init
```

2. Review Configuration
Check variables.tf for default values:

- Region: eu-north-1

- Instance type: t3.micro

- VPC CIDR: 10.0.0.0/16

3. Deploy Infrastructure
```
terraform plan
terraform apply
```

4. Get Connection Details
```
terraform output bastion_public_ip
terraform output k3s_master_private_ip
terraform output k3s_worker_private_ip
```

## Accessing the Cluster

### From Bastion Host

Connect to bastion:
```
ssh -i ~/.ssh/aws-rss-devops-course.pem ubuntu@<BASTION_PUBLIC_IP>
```

Connect to K3s master:
```
ssh ubuntu@<K3S_MASTER_PRIVATE_IP>
```

Check cluster status:
```
sudo k3s kubectl get nodes
sudo k3s kubectl get all --all-namespaces
```

### From Local Computer

Create SSH tunnel:
```
ssh -i ~/.ssh/aws-rss-devops-course.pem -L 6443:10.0.101.188:6443 ubuntu@<BASTION_PUBLIC_IP>
```

Copy kubeconfig (in new terminal):
```
# Get kubeconfig from K3s master
scp -i ~/.ssh/aws-rss-devops-course.pem -o ProxyJump=ubuntu@<BASTION_PUBLIC_IP> ubuntu@<K3S_MASTER_IP>:/home/ubuntu/.kube/config ~/.kube/k3s-config

# Edit for local access
# replace "127.0.0.1" by "localhost" in ~/.kube/k3s-config
```

Use kubectl locally:
```
export KUBECONFIG=~/.kube/k3s-config
kubectl get nodes
kubectl get all --all-namespaces
```

## Cluster Verification

### Check Nodes

```
kubectl get nodes
```

Expected output: 2 nodes (1 master, 1 worker) in Ready state

### Deploy Test Application

```
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
kubectl get pods
kubectl get all --all-namespaces
```

## Troubleshooting

### Memory Issues

If experiencing memory issues on t3.micro instances:
```
# Create swap file
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### K3s Service Issues

```
# Check K3s status
sudo systemctl status k3s
sudo journalctl -u k3s -f

# Restart if needed
sudo systemctl restart k3s
```

### Security Considerations

- All Kubernetes nodes are in private subnets

- Access only through bastion host

- Security groups restrict traffic to necessary ports

- NAT instance provides controlled internet access

## Cleanup

```
terraform destroy
```

### File Structure

```
├── bastion.tf              # Bastion host configuration
├── ec2_instances.tf         # K3s master and worker nodes
├── nat.tf                   # NAT instance configuration
├── security_groups.tf       # Security group definitions
├── vpc.tf                   # VPC, subnets, and routing
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── scripts/
│   ├── k3s-master.sh       # K3s master installation script
│   └── k3s-worker.sh       # K3s worker installation script
└── README.md               # This documentation
```

## Notes

- The cluster uses a custom K3s token for node authentication

- All instances use Ubuntu 24.04 LTS AMI

- Cluster is accessible both from bastion host and local computer via SSH tunnel


