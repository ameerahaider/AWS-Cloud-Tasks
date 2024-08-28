# Retrieve the secret
data "aws_secretsmanager_secret" "github_oauth_token" {
  name = "github-oauth-token"
}

data "aws_secretsmanager_secret_version" "github_oauth_token_version" {
  secret_id = data.aws_secretsmanager_secret.github_oauth_token.id
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
        //OAuthToken = ""  
          OAuthToken = jsondecode(data.aws_secretsmanager_secret_version.github_oauth_token_version.secret_string)["github_token"]
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
      name             = "ElasticBeanstalk_Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ElasticBeanstalk"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration = {
        ApplicationName = var.eb_application_name
        EnvironmentName = var.eb_enviroment_name 
        
      }
    }
  }

}