output "autoscaling_group_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "load_balancer_dns" {
  value       = aws_lb.main.dns_name
  description = "DNS name of the Load Balancer"
}

output "launch_template_id" {
  value       = aws_launch_template.this.id
  description = "Launch Template ID"
}

output "load_balancer_type" {
  value       = aws_lb.main.load_balancer_type
  description = "Type of Load Balancer (application or network)"
}
