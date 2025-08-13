output "autoscaling_group_name" {
  value       = module.asg.autoscaling_group_name
  description = "Name of the Auto Scaling Group"
}

output "load_balancer_dns" {
  value       = module.asg.load_balancer_dns
  description = "DNS name of the Load Balancer"
}

output "launch_template_id" {
  value       = module.asg.launch_template_id
  description = "Launch Template ID"
}

output "load_balancer_type" {
  value       = module.asg.load_balancer_type
  description = "Type of Load Balancer (application or network)"
}
