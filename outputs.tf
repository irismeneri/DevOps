output "website-url" {
  value = "http://${aws_s3_bucket.myweb-app-static-website.bucket}.s3-website.${data.aws_region.current.name}.amazonaws.com"
}
