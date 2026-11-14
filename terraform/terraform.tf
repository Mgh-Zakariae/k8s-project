terraform {
  required_version = ">=1.17"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "amzn-s3-terraform-793886182855-eu-north-1-an"
    key          = "task-manager/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true # native S3 locking (Terraform 1.10+), no DynamoDB table needed
  }
}
