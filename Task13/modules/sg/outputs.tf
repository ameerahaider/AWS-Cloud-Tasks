output "jenkins_sg" {
  description = "The ID of the ECS Node SG"
  value       = aws_security_group.jenkins_sg.id
}

output "app_sg" {
  description = "The ID of the ECS Task SG"
  value       = aws_security_group.app_sg.id
}