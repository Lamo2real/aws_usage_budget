

resource "aws_secretsmanager_secret" "account_secret" {
  name = "my-account-to-access-monthly-billing-bucket"
  description = "this decides who gets to access the monthly billing S3 bucket"
}


variable "secret_value" {
  type = string
  sensitive = true
}

resource "aws_secretsmanager_secret_version" "account_secret_value" {
  secret_id = aws_secretsmanager_secret.account_secret.id
  secret_string = var.secret_value
}


#Because i am an admin user logged in on my aws account using vscode i do have the correct 
#permissions to create, read, put and delete secrets.
