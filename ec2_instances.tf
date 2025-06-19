# EC2 instances for connectivity testing

resource "aws_instance" "test_private_1" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.private.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  tags = {
    Name              = "test-private-1"
    common-course-tag = var.common_course_tag
  }
}

resource "aws_instance" "test_private_2" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[1].id
  vpc_security_group_ids      = [aws_security_group.private.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  tags = {
    Name              = "test-private-2"
    common-course-tag = var.common_course_tag
  }
}

resource "aws_instance" "test_public_1" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.public.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name              = "test-public-1"
    common-course-tag = var.common_course_tag
  }
}
