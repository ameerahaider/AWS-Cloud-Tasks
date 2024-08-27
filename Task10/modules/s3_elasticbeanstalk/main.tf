# Create S3 bucket for storing the application bundle
resource "aws_s3_bucket" "elastic_beanstalk_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.elastic_beanstalk_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.elastic_beanstalk_bucket.id
  acl    = "private"
}

data "archive_file" "nodejs-app" {
  type        = "zip"
  source_dir  = var.app_source_dir
  output_path = var.app_output_path
}

# Upload the application zip file to S3
resource "aws_s3_object" "app_zip" {
  bucket = var.bucket_name
  key    = var.object_key
  source = data.archive_file.nodejs-app.output_path

  depends_on = [
    aws_s3_bucket.elastic_beanstalk_bucket,
    aws_s3_bucket_acl.example
  ]

}
