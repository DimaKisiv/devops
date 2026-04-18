terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }

  # Після першого створення bucket/table розкоментуйте backend нижче,
  # підставте свої значення та виконайте terraform init -reconfigure.
  # backend "s3" {
  #   bucket         = "terraform-state-bucket-dk-lesson-8-9"
  #   key            = "lesson-8-9/terraform.tfstate"
  #   region         = "eu-north-1"
  #   dynamodb_table = "terraform-locks-lesson-8-9"
  #   encrypt        = true
  # }
}