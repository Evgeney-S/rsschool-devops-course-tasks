terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.0.0"
    }
  }
  backend "s3" {
    bucket = "rsschool-devops-course-terraform"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = var.aws_region
}
