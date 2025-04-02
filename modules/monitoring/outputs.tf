output "cloudwatch_log_group_app" {
  description = "The name of the CloudWatch log group for application logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "cloudwatch_log_group_alb" {
  description = "The name of the CloudWatch log group for ALB logs"
  value       = aws_cloudwatch_log_group.alb.name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for logs and backups"
  value       = aws_s3_bucket.logs.id
} 