output "db_instance_endpoint" {
  value = try(aws_db_instance.standard[0].endpoint, null)
  description = "Endpoint for standard RDS instance"
}

output "aurora_cluster_endpoint" {
  value = try(aws_rds_cluster.aurora[0].endpoint, null)
  description = "Endpoint for Aurora cluster"
}

output "aurora_reader_endpoint" {
  value = try(aws_rds_cluster.aurora[0].reader_endpoint, null)
  description = "Reader endpoint for Aurora cluster"
}

output "db_subnet_group" {
  value = aws_db_subnet_group.default.name
  description = "DB Subnet Group name"
}

output "db_security_group_id" {
  value = aws_security_group.rds.id
  description = "Security Group ID for DB"
}
