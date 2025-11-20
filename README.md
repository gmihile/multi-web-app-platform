# Multi-Tier AWS Infrastructure with Terraform

## Overview
Highly Available AWS infrastructure deployed using Infrastructure as Code (Terraform). Implements a highly available, auto-scaling web application architecture across multiple availability zones.

## Architecture Components
- **VPC**: Custom VPC with public/private subnets across 3 AZs
- **Application Load Balancer**: Distributes traffic with health checks
- **Auto Scaling**: EC2 instances scale based on CPU utilization
- **RDS**: Multi-AZ MySQL database in private subnets
- **Route53**: DNS management with ACM SSL certificates
- **Security**: Security groups implementing least-privilege access

## Infrastructure Details
- Auto-scaling triggers: CPU > 70% (scale up), CPU < 20% (scale down)
- Load balancer health checks on `/health` endpoint
- NAT Gateway for private subnet internet access
- CloudWatch alarms for monitoring

## Files
- `vpc.tf` - VPC, subnets, routing, NAT/IGW
- `ec2.tf` - Launch templates, ASG, scaling policies
- `alb.tf` - Application Load Balancer configuration
- `rds.tf` - RDS MySQL database
- `sg.tf` - Security group rules
- `route53.tf` - DNS and SSL certificate management
- `variables.tf` - Input variables
- `output.tf` - Output values

## Deployment
terraform init
terraform plan
terraform apply## Requirements
- Terraform >= 1.0
- AWS CLI configured
- Domain name (for Route53)
