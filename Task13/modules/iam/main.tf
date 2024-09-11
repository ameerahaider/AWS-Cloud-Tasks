# IAM Role for Jenkins EC2 Instance
resource "aws_iam_role" "jenkins_role" {
  name = "${var.name_prefix}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.name_prefix}-jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

# IAM Policy for Jenkins Role (S3 and EC2 Access)
resource "aws_iam_policy" "jenkins_policy" {
  name = "${var.name_prefix}-jenkins-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # EC2 Full Access
        Action = "ec2:*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_role_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}