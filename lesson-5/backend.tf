terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-dk-lesson-5" # Назва S3-бакета
    key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
    region         = "eu-north-1"                    # Регіон AWS
    dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB для блокування
    encrypt        = true                           # Шифрування файлу стейту
  }
}

