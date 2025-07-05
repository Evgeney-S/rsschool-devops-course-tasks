output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion.public_ip
}

output "k3s_master_private_ip" {
  description = "Private IP of K3s master node"
  value       = aws_instance.test_private_1.private_ip
}

output "k3s_worker_private_ip" {
  description = "Private IP of K3s worker node"
  value       = aws_instance.test_private_2.private_ip
}

output "ssh_command_bastion" {
  description = "SSH command to connect to bastion"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.bastion.public_ip}"
}

output "ssh_command_k3s_master" {
  description = "SSH command to connect to K3s master via bastion"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem -J ubuntu@${aws_instance.bastion.public_ip} ubuntu@${aws_instance.test_private_1.private_ip}"
}

output "verification_commands" {
  description = "Commands to verify the cluster"
  value = {
    copy_kubeconfig = "scp -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.test_private_1.private_ip}:/home/ubuntu/.kube/config ~/.kube/config"
    check_nodes     = "kubectl get nodes"
    deploy_test_pod = "kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml"
    check_pod       = "kubectl get pods"
  }
}
