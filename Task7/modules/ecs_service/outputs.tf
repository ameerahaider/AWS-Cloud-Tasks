output "ecs_service_id" {
  value = aws_ecs_service.app.id
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}
