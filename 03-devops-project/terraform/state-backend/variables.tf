variable "aws_region" {
  description = "The AWS region to deploy the backend resources to"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
  default     = "devops-jenkins-tf-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "devops-jenkins-tf-locks"
}
