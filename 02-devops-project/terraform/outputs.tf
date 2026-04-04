output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "private_key_path" {
  description = "Path to the SSH private key"
  value       = local_file.private_key.filename
}
