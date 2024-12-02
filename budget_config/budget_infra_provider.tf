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
