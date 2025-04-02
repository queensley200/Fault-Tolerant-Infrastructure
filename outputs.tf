output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.database.rds_endpoint
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

output "cloudwatch_log_group_app" {
  description = "The name of the CloudWatch log group for application logs"
  value       = module.monitoring.cloudwatch_log_group_app
}

output "cloudwatch_log_group_alb" {
  description = "The name of the CloudWatch log group for ALB logs"
  value       = module.monitoring.cloudwatch_log_group_alb
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for logs and backups"
  value       = module.monitoring.s3_bucket_name
} 