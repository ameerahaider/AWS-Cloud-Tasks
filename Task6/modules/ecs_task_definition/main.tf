 resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name_prefix}-task"
  network_mode             = "awsvpc"
  execution_role_arn = "arn:aws:iam::905418229977:role/ecsTaskExecutionRole"
  cpu                      = var.cpu
  memory                   = var.memory

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = "web-container"
    image     = "ameerahaider/simple-python-server:latest"
    cpu = 256
    memory = 512
    essential = true

    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])

}
