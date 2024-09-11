output "public_ip" {
  description = "The public IP of the server"
  value       = aws_instance.main_server.public_ip
}

output "app_ip" {
  description = "The public IP of the server"
  value       = aws_instance.app.public_ip
}
