
variable "bucket_name" {
  default = "monthly-billing-storage"
}
resource "aws_s3_bucket" "monthly_billing_storage" {
  bucket = var.bucket_name
  
  lifecycle {
    prevent_destroy = true # preventi g accidental destruction with 'terraform destroy' command
  }


  tags = {
    Description = "my monthly billing csv file storage"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "billing_data_lifecycle" {
  bucket = aws_s3_bucket.monthly_billing_storage.bucket

  rule {
    id = "TransitionToGlacierToDeepGlacier"
    status = "Enabled" #indicate that the transition rules are enabled

    transition {
      days = 365
      storage_class = "GLACIER"
    }

    transition {
      days = 730
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

