provider "aws" {
  region = local.aws_region
}

locals {
  aws_region   = "eu-north-1"
  cluster_name = "lesson-7-eks"
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"               # Шлях до модуля
  bucket_name = "terraform-state-bucket-dk-lesson-7" # Ім'я S3-бакета
  table_name  = "terraform-locks"                    # Ім'я DynamoDB
}

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"                               # Шлях до модуля VPC
  vpc_cidr_block     = "10.0.0.0/16"                                 # CIDR блок для VPC
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Публічні підмережі
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # Приватні підмережі
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"] # Зони доступності
  vpc_name           = "vpc"                                         # Ім'я VPC
  eks_cluster_name   = local.cluster_name
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source              = "./modules/eks"
  cluster_name        = local.cluster_name
  cluster_version     = "1.30"
  cluster_subnet_ids  = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  node_subnet_ids     = module.vpc.private_subnets
  node_group_name     = "lesson-7-workers"
  node_instance_types = ["t3.micro"]
  desired_size        = 2
  min_size            = 2
  max_size            = 3
}

