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
