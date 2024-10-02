output "bucket_name" {
  value       = aws_s3_bucket.sccache.id
  description = "id of the sccache bucket"
}

output "secret_key" {
  value     = aws_iam_access_key.credentials.secret
  sensitive = true
}

output "access_key" {
  value     = aws_iam_access_key.credentials.id
  sensitive = true
}
