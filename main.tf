terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-bucket-${random_id.bucket_suffix.hex}"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate random suffix for S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-${random_id.bucket_suffix.hex}"
}

# Enable versioning for state file
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Call our modules
module "networking" {
  source = "./modules/networking"

  environment     = var.environment
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "security" {
  source = "./modules/security"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "compute" {
  source = "./modules/compute"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnet_ids
  private_subnets = module.networking.private_subnet_ids
  alb_sg_id      = module.security.alb_security_group_id
  ec2_sg_id      = module.security.ec2_security_group_id
  app_instance_type = var.app_instance_type
  app_min_size     = var.app_min_size
  app_max_size     = var.app_max_size
  app_desired_capacity = var.app_desired_capacity
}

module "database" {
  source = "./modules/database"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  private_subnets = module.networking.private_subnet_ids
  db_sg_id       = module.security.db_security_group_id
  db_username    = var.db_username
  db_password    = var.db_password
  db_name        = var.db_name
  db_instance_class = var.db_instance_class
}

module "monitoring" {
  source = "./modules/monitoring"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
} 