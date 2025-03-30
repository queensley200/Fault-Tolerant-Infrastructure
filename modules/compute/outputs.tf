output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.app.arn
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.app.id
} 