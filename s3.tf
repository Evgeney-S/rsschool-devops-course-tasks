resource "aws_s3_bucket" "devops_course" {
  bucket = "rsschool-devops-course-terraform-test"
  tags = {
    Name              = "devops-course-bucket"
    common-course-tag = var.common_course_tag
  }
}
