output "bucket_name" {
  value       = aws_s3_bucket.sccache.id
  description = "id of the sccache bucket"
}
