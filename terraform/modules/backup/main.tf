# --- Velero Backup Bucket ---

resource "aws_s3_bucket" "velero" {

  bucket = "${var.name_prefix}-velero-backups"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-velero-backups"
    }
  )
}

# --- Block Public Access ---

resource "aws_s3_bucket_public_access_block" "velero" {

  bucket = aws_s3_bucket.velero.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Versioning ---

resource "aws_s3_bucket_versioning" "velero" {

  bucket = aws_s3_bucket.velero.id

  versioning_configuration {
    status = "Enabled"
  }
}

# --- Encryption ---

resource "aws_s3_bucket_server_side_encryption_configuration" "velero" {

  bucket = aws_s3_bucket.velero.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}

# --- Lifecycle Policy ---

resource "aws_s3_bucket_lifecycle_configuration" "velero" {

  bucket = aws_s3_bucket.velero.id

  rule {

    id     = "expire-old-backups"
    status = "Enabled"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}