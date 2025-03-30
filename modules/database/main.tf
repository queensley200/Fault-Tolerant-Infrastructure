# Create RDS subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# Create RDS instance
resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = var.db_instance_class
  allocated_storage   = 20
  storage_type        = "gp2"
  db_name             = var.db_name
  username           = var.db_username
  password           = var.db_password
  skip_final_snapshot = true

  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  multi_az = true

  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]

  tags = {
    Name        = "${var.environment}-db"
    Environment = var.environment
  }
}

# Create CloudWatch log group for RDS
resource "aws_cloudwatch_log_group" "rds" {
  name              = "/aws/rds/${var.environment}-db"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-db-logs"
    Environment = var.environment
  }
}

# Create CloudWatch alarm for RDS CPU utilization
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.environment}-rds-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period             = 300
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "This metric monitors RDS CPU utilization"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = {
    Name        = "${var.environment}-rds-cpu"
    Environment = var.environment
  }
}

# Create CloudWatch alarm for RDS free storage space
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.environment}-rds-free-storage-space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period             = 300
  statistic          = "Average"
  threshold          = 1000000000 # 1GB in bytes
  alarm_description  = "This metric monitors RDS free storage space"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = {
    Name        = "${var.environment}-rds-storage"
    Environment = var.environment
  }
} 