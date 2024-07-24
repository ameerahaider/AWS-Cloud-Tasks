resource "aws_ecs_task_definition" "this" {
  family                   = var.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions    = jsonencode([{

    name  = var.container_name
    image = var.container_image
    essential = true

    portMappings = [{
      
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.main_SG]
    assign_public_ip = true
  }
}