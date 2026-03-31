variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devops-static-site"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
