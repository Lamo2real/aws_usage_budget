
variable "bucket_name" {
  default = "monthly-billing-storage"
}
resource "aws_s3_bucket" "monthly_billing_storage" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true # preventing accidental destruction with 'terraform destroy' command
  }



  tags = {
    Description = "my monthly billing csv file storage"
    Environment = "Dev"
  }
}


data "aws_secretsmanager_secret_version" "account_secret_version" {
  secret_id = aws_secretsmanager_secret.account_secret.id
}



resource "aws_s3_bucket_policy" "monthly_billing_storage_policy" {
  bucket = aws_s3_bucket.monthly_billing_storage.bucket

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "Policy1335892530063"
    Statement = [
      {
        Sid       = "Stmt1335892150622"
        Effect    = "Allow"
        Principal = { Service = "billingreports.amazonaws.com" }
        Action    = [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ]
        Resource = "arn:aws:s3:::monthly-billing-storage"
        Condition = {
          StringEquals = {
            "aws:SourceArn"    = "arn:aws:cur:us-east-1:${data.aws_secretsmanager_secret_version.account_secret_version.secret_string}:definition/*"
            "aws:SourceAccount" = "${data.aws_secretsmanager_secret_version.account_secret_version.secret_string}"
          }
        }
      },
      {
        Sid       = "Stmt1335892526596"
        Effect    = "Allow"
        Principal = { Service = "billingreports.amazonaws.com" }
        Action    = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::monthly-billing-storage/*"
        Condition = {
          StringEquals = {
            "aws:SourceArn"    = "arn:aws:cur:us-east-1:${data.aws_secretsmanager_secret_version.account_secret_version.secret_string}:definition/*"
            "aws:SourceAccount" = "${data.aws_secretsmanager_secret_version.account_secret_version.secret_string}"
          }
        }
      }
    ]
  })

}


resource "aws_s3_bucket_lifecycle_configuration" "billing_data_lifecycle" {
  bucket = aws_s3_bucket.monthly_billing_storage.bucket

  rule {
    id     = "TransitionToGlacierToDeepGlacier"
    status = "Enabled" #indicate that the transition rules are enabled

    transition {
      days          = 365
      storage_class = "GLACIER"
    }

    transition {
      days          = 730
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

