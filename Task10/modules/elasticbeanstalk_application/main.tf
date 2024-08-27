resource "aws_elastic_beanstalk_application" "eb-application" {
  name        = "${var.name_prefix}-nodejs-app"
  description = "Simple NodeJS Application deployment using Elastic Beanstalk"
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "eb-application-ver" {
  name        = "${var.name_prefix}-app-version"
  application = aws_elastic_beanstalk_application.eb-application.name
  description = "v1 of application version created by terraform"
  bucket      = var.s3_bucket_id
  key         = var.s3_object_key
}
