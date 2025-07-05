variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = "314146315305"
}

variable "github_actions_role_name" {
  description = "IAM Role name for GitHub Actions"
  type        = string
  default     = "GithubActionsRole"
}

variable "github_user" {
  description = "GitHub user or organization name"
  type        = string
  default     = "Evgeney-S"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "rsschool-devops-course-tasks"
}

variable "common_course_tag" {
  description = "Common tag for all resources in the course"
  type        = string
  default     = "AWS-DevOps-course-2025Q2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "ec2_ami" {
  description = "AMI for EC2 instanses, NAT and bastion host"
  default     = "ami-042b4708b1d05f512"
}

variable "instance_type" {
  description = "Instance type for bastion and NAT"
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name for EC2"
  default     = "aws-rss-devops-course"
}

variable "k3s_token" {
  description = "Token for K3s cluster"
  type        = string
  default     = "aws-rss-devops-course-k3s-token"
  sensitive   = true
}

locals {
  k3s_token = var.k3s_token != "" ? var.k3s_token : random_password.k3s_token.result
}
