terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.38.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-bucket-dk-7" # Назва S3-бакета
    key            = "lesson-7/terraform.tfstate"   # Шлях до файлу стейту
    region         = "eu-north-1"                    # Регіон AWS
    dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB для блокування
    encrypt        = true                           # Шифрування файлу стейту
  }
}

