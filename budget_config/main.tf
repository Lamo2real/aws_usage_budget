
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}

#this is automatically assigned to the region that i used in my 'aws configure'
#but for version control and best practice purposes i still have it mentioned in the IaC
provider "aws" {
  region = "eu-central-1"
}

resource "aws_budgets_budget" "my_monthly_budget" {
  name = "my_monthly_budget"
  budget_type = "COST"
  limit_amount = "15.0"
  limit_unit = "USD"
  time_unit = "MONTHLY"
  time_period_start = "2024-11-30_12:30"

    notification {
      comparison_operator = "GREATER_THAN"
      notification_type = "ACTUAL"
      threshold = 80.0
      threshold_type = "PERCENTAGE"      
      subscriber_email_addresses = [ var.notification_email ]
    }

    tags = {
        Tag1 = "SAA-CO3"
    }
}

