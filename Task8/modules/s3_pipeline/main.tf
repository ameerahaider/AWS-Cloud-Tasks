resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "${var.name_prefix}-pipeline-artifacts-bucket"
}

resource "aws_s3_bucket_policy" "pipeline_artifacts_policy" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.pipeline_artifacts.id}",
          "arn:aws:s3:::${aws_s3_bucket.pipeline_artifacts.id}/*"
        ]
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.pipeline_artifacts.id}",
          "arn:aws:s3:::${aws_s3_bucket.pipeline_artifacts.id}/*"
        ]
      }
    ]
  })
}
