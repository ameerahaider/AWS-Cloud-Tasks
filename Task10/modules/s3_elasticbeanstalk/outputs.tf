output "s3_bucket_name" {
  value = aws_s3_bucket.elastic_beanstalk_bucket.bucket
}

output "s3_bucket_id" {
  value = aws_s3_bucket.elastic_beanstalk_bucket.id
}

output "s3_object_key" {
  value = aws_s3_object.app_zip.key
}


