resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name
  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.demo_bucket.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}