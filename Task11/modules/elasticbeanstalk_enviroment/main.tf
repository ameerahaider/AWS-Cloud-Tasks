# Reference existing IAM roles
data "aws_iam_role" "eb_service_role" {
  name = "aws-elasticbeanstalk-service-role"
}

data "aws_iam_role" "eb_instance_role" {
  name = "beanstalkEC2InstanceProfileRole"
}

# IAM Instance Profile for EC2 Instances
data "aws_iam_instance_profile" "eb_instance_profile" {
  name = "beanstalkEC2InstanceProfileRole"
}
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eb-environment" {
  name                = "${var.name_prefix}-nodejs-environment"
  application         = var.eb_application_name
  solution_stack_name = var.solution_stack_name
  //https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platform-history-nodejs.html

  # Specify the EC2 instance profile
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = data.aws_iam_instance_profile.eb_instance_profile.name
  }
}
