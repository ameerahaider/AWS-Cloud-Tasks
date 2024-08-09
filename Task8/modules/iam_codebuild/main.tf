resource "aws_iam_role" "codebuild_role" {
  name = "${var.name_prefix}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_power_user" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.name_prefix}-codebuild_policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:905418229977:log-group:/aws/codebuild/*",
          "arn:aws:logs:us-east-1:905418229977:log-group:/aws/codebuild/*:log-stream:*"
        ]
      },
      {
        Effect = "Allow",
        Resource = [
                    "arn:aws:logs:us-east-1:905418229977:log-group:/aws/codebuild/*",
          //"arn:aws:logs:us-east-1:905418229977:log-group:/aws/codebuild/Ameera-codebuild",
          //"arn:aws:logs:us-east-1:905418229977:log-group:/aws/codebuild/Ameera-codebuild:*"
        ],
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow",
        Resource = [
          "*"
          //"arn:aws:s3:::ameera-pipeline-artifacts-bucket",
          //"arn:aws:s3:::ameera-pipeline-artifacts-bucket/*"
        ],
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource = [
                    "arn:aws:codebuild:us-east-1:905418229977:report-group/*"
          //"arn:aws:codebuild:us-east-1:905418229977:report-group/Ameera-codebuild-*"
        ]
      }
    ]
  })
}