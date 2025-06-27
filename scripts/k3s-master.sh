#!/bin/bash
set -e

# Update system
apt-get update
apt-get install -y curl

# Install k3s server
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--token=${k3s_token} --write-kubeconfig-mode=644" sh -

# Wait for k3s to be ready
sleep 30

# Create kubeconfig for remote access
mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sed -i 's/127.0.0.1/0.0.0.0/g' /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

# Install kubectl on master for convenience
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Enable and start k3s
systemctl enable k3s
systemctl start k3s

# Wait for node to be ready
kubectl wait --for=condition=Ready node --all --timeout=300s
