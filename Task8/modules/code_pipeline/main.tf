data "aws_secretsmanager_secret_version" "github_oauth_token" {
  secret_id = "github-oauth-token"
}

resource "aws_codepipeline" "app_pipeline" {
  name     = "${var.name_prefix}-app-pipeline"
  role_arn = var.iam_codepipeline_arn

  artifact_store {
    location = var.s3_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.repo_owner 
        Repo       = var.repo_name 
        Branch     = var.repo_branch                                     
        OAuthToken = jsondecode(data.aws_secretsmanager_secret_version.github_oauth_token.secret_string)["GITHUB_OAUTH_TOKEN"] 
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.code_build_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "DeployToECS"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration = {
        ClusterName        = var.ecs_cluster_name
        ServiceName        = var.ecs_service_name
        FileName           = "imagedefinitions.json"
      }
    }
  }
}