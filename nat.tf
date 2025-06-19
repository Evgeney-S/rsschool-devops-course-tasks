resource "aws_instance" "nat" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = [aws_security_group.nat.id]
  key_name                    = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Enable IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
    
    # Configure NAT with iptables
    apt-get update
    apt-get install -y iptables-persistent
    iptables -t nat -A POSTROUTING -o eth0 -s ${var.vpc_cidr} -j MASQUERADE
    netfilter-persistent save
  EOF

  tags = {
    Name              = "nat-instance"
    common-course-tag = var.common_course_tag
  }
}

