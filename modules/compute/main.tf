# Create Application Load Balancer
resource "aws_lb" "app" {
  name               = "${var.environment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]

  dynamic "subnet_mapping" {
    for_each = var.public_subnets
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name        = "${var.environment}-app-alb"
    Environment = var.environment
  }
}

# Create ALB target group
resource "aws_lb_target_group" "app" {
  name     = "${var.environment}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    timeout             = 5
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.environment}-app-tg"
    Environment = var.environment
  }
}

# Create ALB listener
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name        = "${var.environment}-app-listener"
    Environment = var.environment
  }
}

# Create launch template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-template"
  image_id      = "ami-0f1c3f3f1f1f1f1f1"  # Amazon Linux 2 AMI ID for eu-north-1
  instance_type = var.app_instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups            = [var.ec2_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to ${var.environment} environment</h1>" > /var/www/html/index.html
              EOF
  )

  tags = {
    Name        = "${var.environment}-app-lt"
    Environment = var.environment
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  desired_capacity    = var.app_desired_capacity
  max_size           = var.app_max_size
  min_size           = var.app_min_size
  target_group_arns  = [aws_lb_target_group.app.arn]
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value              = "${var.environment}-app-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value              = var.environment
    propagate_at_launch = true
  }
}

# Create Auto Scaling Policy
resource "aws_autoscaling_policy" "app" {
  name                   = "${var.environment}-app-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown              = 300
}

# Create CloudWatch Alarm for CPU utilization
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.environment}-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period             = 120
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "This metric monitors EC2 CPU utilization"
  alarm_actions      = [aws_autoscaling_policy.app.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  tags = {
    Name        = "${var.environment}-cpu-high"
    Environment = var.environment
  }
} 