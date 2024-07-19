output "main_SG" {
  description = "The ID of the Application Server SG"
  value       = aws_security_group.main-sg.id
}