# --- ECS Task Definition ---

resource "aws_ecs_task_definition" "app" {
  family             = "${var.name_prefix}-app"
  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_exec_role_arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 256

  volume {
    name = "efs-volume"

    efs_volume_configuration {
      file_system_id = var.efs_id

      root_directory = "/"
      
      transit_encryption = "ENABLED"
    }
  }

  container_definitions = jsonencode([{
    name         = "app",
    image        = "${var.ecr_repo_url}:latest",
    essential    = true,
    portMappings = [{ containerPort = 80, hostPort = 80 }],

    mountPoints = [{
      sourceVolume  = "efs-volume"
      containerPath = "/mnt/efs"
      readOnly = false
    }]

    environment = [
      { name = "EXAMPLE", value = "example" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = var.cloud_watch_group_name,
        "awslogs-stream-prefix" = "app"
      }
    },
  }])
}