output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "db_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.db.id
}

output "ec2_role_arn" {
  description = "The ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "rds_role_arn" {
  description = "The ARN of the RDS IAM role"
  value       = aws_iam_role.rds_role.arn
} 