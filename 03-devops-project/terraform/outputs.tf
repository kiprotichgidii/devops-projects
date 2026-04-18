output "public_ip" {
  description = "Public IP of the web instance"
  value       = aws_instance.web.public_ip
}
