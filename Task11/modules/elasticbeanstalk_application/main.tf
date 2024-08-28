resource "aws_elastic_beanstalk_application" "eb-application" {
  name        = "${var.name_prefix}-nodejs-app"
  description = "Simple NodeJS Application deployment using Elastic Beanstalk"
}
