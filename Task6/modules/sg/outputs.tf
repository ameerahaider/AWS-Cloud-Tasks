output "ecs-node-sg" {
  description = "The ID of the ECS Node SG"
  value       = aws_security_group.ecs-node-sg.id
}

output "ecs-task-sg" {
  description = "The ID of the ECS Task SG"
  value       = aws_security_group.ecs-task-sg.id
}

output "alb-sg" {
  description = "The ID of the Application Load Balancer SG"
  value       = aws_security_group.alb-sg.id
}

output "efs-sg" {
  description = "The ID of the EFS SG"
  value       = aws_security_group.efs-sg.id
}
