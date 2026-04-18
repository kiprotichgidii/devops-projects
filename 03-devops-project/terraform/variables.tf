variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "jenkins-server"
}

variable "instance_type" {
  description = "EC2 instance type (t3.small is recommended for Jenkins)"
  type        = string
  default     = "t3.small"
}
