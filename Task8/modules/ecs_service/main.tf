# --- ECS Service ---
resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_arn
  desired_count   = 2

  network_configuration {
    security_groups = [var.ecs_task_sg]
    subnets         = var.public_subnet_ids
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 80
  }
}
