output "application_name" {
  value = aws_elastic_beanstalk_application.eb-application.name
}

output "application_version_name" {
  value = aws_elastic_beanstalk_application_version.eb-application-ver.name
}
