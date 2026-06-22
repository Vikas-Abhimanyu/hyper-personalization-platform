output "velero_bucket_name" {

  description = "Velero backup bucket"

  value = aws_s3_bucket.velero.bucket
}