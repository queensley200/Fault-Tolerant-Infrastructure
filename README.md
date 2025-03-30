# Fault-Tolerant AWS Infrastructure

This repository contains Terraform configurations for a highly available, secure, and fault-tolerant AWS infrastructure. The infrastructure includes:

- VPC with public and private subnets across multiple Availability Zones
- Application Load Balancer and Auto Scaling Group for the application layer
- RDS instance with multi-AZ deployment for high availability
- CloudWatch monitoring and logging
- S3 bucket for logs and backups
- Security groups and IAM roles for secure access

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0.0 or later)
- AWS account with appropriate permissions

## Infrastructure Components

### Networking
- VPC with CIDR block 10.0.0.0/16
- 2 public subnets and 2 private subnets across multiple AZs
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- Route tables for public and private subnets

### Compute
- Application Load Balancer in public subnets
- Auto Scaling Group with EC2 instances in private subnets
- Launch template with Ubuntu 22.04 LTS
- CloudWatch alarms for CPU utilization

### Database
- RDS MySQL instance in private subnets
- Multi-AZ deployment for high availability
- Automated backups enabled
- CloudWatch monitoring and logging

### Security
- Security groups for ALB, EC2, and RDS
- IAM roles and policies for EC2 and RDS
- SSL/TLS encryption for application traffic
- Server-side encryption for S3 buckets

### Monitoring
- CloudWatch log groups for application and ALB logs
- CloudWatch dashboard for monitoring
- S3 bucket for logs and backups
- CloudWatch alarms for RDS metrics

## Deployment Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fault-tolerant-infrastructure
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Create a `terraform.tfvars` file with your configuration:
   ```hcl
   environment = "prod"
   aws_region = "us-west-2"
   db_username = "admin"
   db_password = "your-secure-password"
   ```

4. Review the planned changes:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

6. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

## Important Notes

- The infrastructure uses multiple Availability Zones for high availability
- All sensitive data is encrypted at rest
- Automated backups are enabled for the RDS instance
- CloudWatch monitoring and logging are configured for all components
- Security groups are configured to allow only necessary traffic
- IAM roles follow the principle of least privilege

## Cost Considerations

- The infrastructure uses t3.micro instances for EC2 and RDS
- Multi-AZ deployment for RDS will incur additional costs
- NAT Gateway usage will incur hourly charges
- Consider using AWS Free Tier eligible resources for development/testing

## Security Best Practices

- All sensitive data is marked as sensitive in Terraform
- Security groups are configured with minimal required access
- IAM roles follow the principle of least privilege
- All storage is encrypted at rest
- Network traffic is encrypted in transit

## Monitoring and Maintenance

- CloudWatch alarms are configured for CPU utilization
- Logs are retained for 30 days
- Automated backups are configured for RDS
- S3 bucket versioning is enabled for data durability

## Support

For issues and questions, please create an issue in the repository. 