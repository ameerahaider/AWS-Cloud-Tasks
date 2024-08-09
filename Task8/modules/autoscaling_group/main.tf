# -------- Launch Template
data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name            = "${var.name_prefix}-launch-template"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.ecs_node_sg_id]

  iam_instance_profile { arn = var.ecs_node_profile_arn}
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config;
    EOF
  )

    tags = {
    Name = "${var.name_prefix}-launch-template"
  }
}


# -------- Auto Scaling Group

resource "aws_autoscaling_group" "ecs" {

  name               = "${var.name_prefix}-ecs-asg-"
  vpc_zone_identifier       = var.public_subnet_ids 
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }
  

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}