output "vpc_id" {
    description = "The vpc id"
    value = aws_vpc.vpc.id
}



output "alb_dns_name" {
  description = "Application load balancer dns name"
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "Application load balancer ARN value"
  value = aws_lb.alb.arn

}

output "domain_url" {
  description = "Domain url with the http protocol "
  value = "http://${aws_route53_zone.main_hosted_zone.name}"
}

output "domain_url_https" {
  description = "Domain url "
  value = "https://${aws_route53_zone.main_hosted_zone.name}"

}

output "domain_name" {
  description = "Domain name"
  value = aws_route53_zone.main_hosted_zone.name

}

output "route_53_name_servers" {
  description = "name servers of the route 53 server"
  value = aws_route53_zone.main_hosted_zone.name_servers
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.db_instance.endpoint
  sensitive   = true  # Mark as sensitive
}

output "rds_address" {
  description = "RDS database address (hostname only)"
  value       = aws_db_instance.db_instance.address
  sensitive   = true # Mark  as sensitive
}


output "rds_port" {
  description = "database port"
  value = aws_db_instance.db_instance.port

}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.alb_tg_group.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg_web_app.name
}

output "alb_security_group_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "Security group ID for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  description = "Security group ID for RDS database"
  value       = aws_security_group.rds_db_sg.id
}
