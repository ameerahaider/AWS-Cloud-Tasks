data "aws_instances" "example" {
  instance_tags = {
    Name = "${var.name_prefix}-asg-instance"
  }
}

output "private_ips" {
  value = data.aws_instances.example.private_ips
}

output "auto_scaling_group_arn" {
  value = aws_autoscaling_group.asg.arn
}


