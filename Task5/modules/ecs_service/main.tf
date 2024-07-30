resource "aws_ecs_service" "main" {
  name            = "${var.name_prefix}-service"
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets_id
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "web-container"
    container_port   = 80
  }
}
