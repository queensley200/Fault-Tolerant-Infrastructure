output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "rds_identifier" {
  description = "The identifier of the RDS instance"
  value       = aws_db_instance.main.identifier
}

output "rds_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.main.name
} 