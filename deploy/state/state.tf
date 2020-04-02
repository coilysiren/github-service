resource "aws_kms_key" "state_key" {
  description             = "This key is used to encrypt the terraform state for ${var.NAME}"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.STATE_BUCKET_NAME

  # 🔐
  acl = "private"

  # server side encrypt by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # encourage immutable infrastructure!
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  # versioning essentially required with object lock
  versioning {
    enabled = true
  }
}

# 🔐 private bucket is private
resource "aws_s3_bucket_public_access_block" "state_bucket_access_block" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
