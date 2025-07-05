#!/bin/bash
set -e

# Update system
apt-get update
apt-get install -y curl

# Wait for master to be ready with retry logic
for i in {1..10}; do
  if curl -k https://${master_ip}:6443/ping; then
    echo "Master is ready"
    break
  fi
  echo "Waiting for master... attempt $i/10"
  sleep 30
done

# Install k3s agent
curl -sfL https://get.k3s.io | K3S_URL=https://${master_ip}:6443 K3S_TOKEN=${k3s_token} sh -

# Enable and start k3s-agent
systemctl enable k3s-agent
systemctl start k3s-agent
