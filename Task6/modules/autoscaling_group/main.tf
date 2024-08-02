# Data source to get the most recent ECS AMI
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix            = "${var.name_prefix}-ecs-launch-template"
  image_id               = data.aws_ami.ecs_ami.id
  //image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
      set -x

      # Update the package repository
      # sudo yum update -y

      # Enable ecs in Amazon Linux Extras and install ecs-init
      amazon-linux-extras enable ecs
      sudo yum install -y ecs-init

      # Enable and start the Docker and ECS service
      sudo systemctl start docker
      sudo systemctl start ecs

      # Wait for ECS service to start
      sleep 15

      # Configure the ECS cluster
      echo ECS_CLUSTER=clustername >> sudo /etc/ecs/ecs.config
      sudo systemctl start docker
      sudo systemctl start ecs
    EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-ecs-instance"
    }
  }
}


resource "aws_autoscaling_group" "asg" {
  desired_capacity           = var.desired_capacity
  max_size                   = var.max_size
  min_size                   = var.min_size
  vpc_zone_identifier        = var.public_subnet_ids

  
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

