output "ecs-sg" {
  description = "The ID of the ECS SG"
  value       = aws_security_group.ecs-sg.id
}

output "efs-sg" {
  description = "The ID of the EFS SG"
  value       = aws_security_group.efs-sg.id
}

output "alb-sg" {
  description = "The ID of the Application Load Balancer SG"
  value       = aws_security_group.alb-sg.id
}
