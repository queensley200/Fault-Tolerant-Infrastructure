# Create S3 bucket for logs and backups
resource "aws_s3_bucket" "logs" {
  bucket = "${var.environment}-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-logs"
    Environment = var.environment
  }
}

# Enable versioning for the logs bucket
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create CloudWatch log group for application logs
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ec2/${var.environment}-app"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-app-logs"
    Environment = var.environment
  }
}

# Create CloudWatch log group for ALB logs
resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/alb/${var.environment}-alb"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-alb-logs"
    Environment = var.environment
  }
}

# Create CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.environment}-app-asg"],
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.environment}-app-asg", { "stat": "Maximum" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "EC2 CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.environment}-db"],
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.environment}-db", { "stat": "Maximum" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "RDS CPU Utilization"
        }
      }
    ]
  })
}

# Generate random suffix for S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Get current AWS region
data "aws_region" "current" {} 