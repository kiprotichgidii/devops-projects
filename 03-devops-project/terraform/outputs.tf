output "jenkins_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  description = "The URL to access the Jenkins web interface"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "jenkins_agent_public_ip" {
  description = "Public IP of the Jenkins agent"
  value       = aws_instance.jenkins_agent.public_ip
}
