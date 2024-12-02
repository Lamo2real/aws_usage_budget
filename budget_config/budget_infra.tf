

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

