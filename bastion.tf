resource "aws_instance" "bastion" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name

  user_data_base64 = base64encode(templatefile("${path.module}/scripts/bastion-setup.sh", {}))

  tags = {
    Name = "bastion-host"
  }
}
