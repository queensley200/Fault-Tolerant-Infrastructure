variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the ALB security group"
  type        = string
}

variable "ec2_sg_id" {
  description = "The ID of the EC2 security group"
  type        = string
}

variable "app_instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
}

variable "app_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "app_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "app_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
} 