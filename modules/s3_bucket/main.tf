resource "aws_s3_bucket" "myweb-app-static-website" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "myweb-app-static-website" {
  bucket = aws_s3_bucket.myweb-app-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "myweb-app-static-website" {
  bucket = aws_s3_bucket.myweb-app-static-website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket ACL access
resource "aws_s3_bucket_ownership_controls" "myweb-app-static-website" {
  bucket = aws_s3_bucket.myweb-app-static-website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "myweb-app-static-website" {
  bucket = aws_s3_bucket.myweb-app-static-website.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "myweb-app-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.myweb-app-static-website,
    aws_s3_bucket_public_access_block.myweb-app-static-website,
  ]

  bucket = aws_s3_bucket.myweb-app-static-website.id
  acl = "public-read"
}
