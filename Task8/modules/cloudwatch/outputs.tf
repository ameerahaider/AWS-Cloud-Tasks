output "cloud_watch_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}