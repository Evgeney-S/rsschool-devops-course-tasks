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
    
    # Use ens5 interface instead of eth0 for Ubuntu 24.04
    IFACE=$(ip -o -4 route show to default | awk '{print $5}')
    iptables -t nat -A POSTROUTING -o $IFACE -s ${var.vpc_cidr} -j MASQUERADE
    netfilter-persistent save
    
    # Verify configuration
    echo "Using interface: $IFACE for NAT"
    sysctl net.ipv4.ip_forward
    iptables -t nat -L -v
  EOF

  tags = {
    Name              = "nat-instance"
    common-course-tag = var.common_course_tag
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

