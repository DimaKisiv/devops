# Universal RDS/Aurora Terraform Module

## Usage Example

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = true
  aurora_instance_count      = 2

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

## Variables

- `name` — Назва інстансу або кластера
- `use_aurora` — true для Aurora, false для звичайної RDS
- `aurora_instance_count` — Кількість інстансів у кластері Aurora
- `aurora_replica_count` — Кількість read-only реплік Aurora
- `engine` — Двигун для RDS (наприклад, "postgres")
- `engine_version` — Версія для RDS (наприклад, "17.2")
- `parameter_group_family_rds` — Родина параметрів для RDS (наприклад, "postgres17")
- `engine_cluster` — Двигун для Aurora (наприклад, "aurora-postgresql")
- `engine_version_cluster` — Версія Aurora (наприклад, "15.3")
- `parameter_group_family_aurora` — Родина параметрів для Aurora (наприклад, "aurora-postgresql15")
- `instance_class` — Тип EC2-інстансу (наприклад, "db.t3.medium")
- `allocated_storage` — Розмір сховища (ГБ)
- `db_name` — Назва бази даних
- `username` — Користувач
- `password` — Пароль
- `subnet_private_ids` — Список приватних сабнетів
- `subnet_public_ids` — Список публічних сабнетів
- `publicly_accessible` — true/false
- `vpc_id` — ID VPC
- `multi_az` — true/false
- `backup_retention_period` — Кількість днів для бекапів
- `parameters` — Карта параметрів для параметр-групи
- `tags` — Карта тегів

## How to Switch DB Type, Engine, Instance Class

- Щоб створити Aurora, встановіть `use_aurora = true` і задайте Aurora-параметри (`engine_cluster`, `engine_version_cluster`, `parameter_group_family_aurora`).
- Для звичайної RDS — `use_aurora = false` і задайте RDS-параметри (`engine`, `engine_version`, `parameter_group_family_rds`).
- Для зміни типу інстансу, версії або параметрів просто змініть відповідні змінні у блоці module.

## Outputs

- `db_instance_endpoint` — Endpoint для стандартної RDS
- `aurora_cluster_endpoint` — Endpoint для Aurora
- `aurora_reader_endpoint` — Reader endpoint для Aurora
- `db_subnet_group` — Назва subnet group
- `db_security_group_id` — ID security group
