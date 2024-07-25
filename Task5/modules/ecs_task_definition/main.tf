resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  
  /*
  volume {
    name = "efs-volume"

    efs_volume_configuration {
      file_system_id = var.efs_id

      root_directory = "/"
      
      transit_encryption = "ENABLED"
    }
  }
  */

  container_definitions = jsonencode([{
    name      = "nginx-app"
    image     = var.image
    essential = true

    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]

    /*
    mountPoints = [{
      sourceVolume  = "efs-volume"
      containerPath = "/usr/share/nginx/html"
    }]
    */

  }])

}
