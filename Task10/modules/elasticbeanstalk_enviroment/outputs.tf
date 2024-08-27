output "environment_name" {
  value = aws_elastic_beanstalk_environment.eb-environment.name
}

output "environment_endpoint" {
  value = aws_elastic_beanstalk_environment.eb-environment.endpoint_url
}
