provider "aws" {
  region = var.region
}

locals {

  tags = {
    Terraform = "true"
    Name      = "opendatahub-io/vllm-sccache"
    Owner     = "dtrifiro@redhat.com"
    Url       = "github.com/opendatahub-io/vllm"
    Team      = "OpenShift AI Model Serving"
  }
}

resource "aws_s3_bucket" "sccache" {
  bucket = var.bucket_name

  tags = local.tags
}


resource "aws_s3_bucket_ownership_controls" "sccache" {
  bucket = aws_s3_bucket.sccache.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "sccache" {
  bucket = aws_s3_bucket.sccache.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "sccache" {
  depends_on = [
    aws_s3_bucket_ownership_controls.sccache,
    aws_s3_bucket_public_access_block.sccache,
  ]

  bucket = aws_s3_bucket.sccache.id
  acl    = "public-read"
}


resource "aws_iam_user" "ci_user" {
  name = "${var.bucket_name}-ci-user"

  # tags = local.tags # I don't have the permissions to tag a user
}

resource "aws_s3_bucket_policy" "sccache" {
  bucket = aws_s3_bucket.sccache.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.sccache.arn}/*"
      },
      {
        Sid    = "CustomWriteAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.ci_user.arn
        }
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl",
        ]
        Resource = "${aws_s3_bucket.sccache.arn}/*"
      },
    ]
  })
}

resource "aws_iam_access_key" "credentials" {
  user = aws_iam_user.ci_user.name
}

