resource "aws_instance" "nat" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = [aws_security_group.nat.id]
  key_name                    = var.key_name
  tags = {
    Name              = "nat-instance"
    common-course-tag = var.common_course_tag
  }
}

