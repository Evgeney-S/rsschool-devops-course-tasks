# K3s Master Node (previously test_private_1)
resource "aws_instance" "test_private_1" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data_base64 = base64encode(templatefile("${path.module}/scripts/k3s-master.sh", {
    k3s_token = local.k3s_token
  }))

  tags = {
    Name = "k3s-master"
    Role = "k3s-master"
  }
}

# K3s Worker Node (previously test_private_2)
resource "aws_instance" "test_private_2" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[1].id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data_base64 = base64encode(templatefile("${path.module}/scripts/k3s-worker.sh", {
    k3s_token = local.k3s_token
    master_ip = aws_instance.test_private_1.private_ip
  }))

  depends_on = [aws_instance.test_private_1]

  tags = {
    Name = "k3s-worker"
    Role = "k3s-worker"
  }
}

resource "random_password" "k3s_token" {
  length  = 32
  special = false
}
