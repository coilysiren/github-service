# purpose: enable server side state encryption
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/kms_key.html
# aws docs: https://docs.aws.amazon.com/kms/latest/developerguide/getting-started.html
resource "aws_kms_key" "state_key" {
  description             = "This key is used to encrypt the terraform state for ${var.NAME}"
  deletion_window_in_days = 10
}

# purpose: store the terraform state
#
# terraform docs: https://www.terraform.io/docs/providers/aws/d/s3_bucket.html
# aws docs: https://docs.aws.amazon.com/AmazonS3/latest/dev/Introduction.html
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

# purpose: make the state bucket more private 🔐
#
# terraform docs: https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html
# aws docs: https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html
resource "aws_s3_bucket_public_access_block" "state_bucket_access_block" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
