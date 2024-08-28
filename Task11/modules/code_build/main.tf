resource "aws_codebuild_project" "app_build" {
  name         = "${var.name_prefix}-app-build"
  description   = "Build project for Elastic Beanstalk Application"

  service_role = var.iam_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"

  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true # Enable Docker commands
    environment_variable {
      name  = "S3_BUCKET_NAME"
      value = var.s3_bucket_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}