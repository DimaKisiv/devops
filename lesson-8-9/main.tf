provider "aws" {
  region = local.aws_region
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.aws_region]
    }
  }
}

locals {
  aws_region   = "eu-north-1"
  cluster_name = "lesson-8-9-eks"
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"               # Шлях до модуля
  bucket_name = "terraform-state-bucket-dk-lesson-8-9" # Ім'я S3-бакета
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
  ecr_name     = "lesson-8-9-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source              = "./modules/eks"
  cluster_name        = local.cluster_name
  cluster_version     = "1.30"
  cluster_subnet_ids  = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  node_subnet_ids     = module.vpc.private_subnets
  node_group_name     = "lesson-8-9-workers"
  node_instance_types = ["t3.small"]
  desired_size        = 4
  min_size            = 2
  max_size            = 5
}

module "jenkins" {
  source              = "./modules/jenkins"
  cluster_name        = module.eks.cluster_name
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  ecr_repository_arn  = module.ecr.repository_arn
  ecr_repository_url  = module.ecr.repository_url

  providers = {
    helm = helm
  }
}

module "argo_cd" {
  source = "./modules/argo_cd"

  providers = {
    helm = helm
  }
}

module "rds" {
  source = "./modules/rds"

  name                       = "lesson-8-9-db"
  use_aurora                 = false
  aurora_instance_count      = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.6"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  db_name                    = "lesson89"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = false
  backup_retention_period    = 1
  parameters = {
    max_connections              = "100"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "lesson-8-9"
  }
}

