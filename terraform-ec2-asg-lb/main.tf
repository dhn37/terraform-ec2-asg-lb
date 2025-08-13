resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(var.user_data)
  vpc_security_group_ids = var.security_group_ids
}

resource "aws_lb" "main" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = var.intended_access_protocol == "HTTP" ? "application" : "network"
  subnets            = var.lb_subnets
 # security_groups    = var.alb_security_group_ids != null ? var.alb_security_group_ids : null   # Can be used if a specific SG is to be used for the ALB; otherwise, it defaults to the VPC's default SG
}

resource "aws_lb_target_group" "main" {
  name     = "${var.name}-tg"
  port     = var.lb_port
  protocol = var.intended_access_protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "main" {
  count             = var.intended_access_protocol == "HTTP" ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = var.lb_port
  protocol          = var.intended_access_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "nlb_tcp" {
  count             = var.intended_access_protocol == "TCP" ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = var.lb_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_autoscaling_group" "this" {
  name               = var.name
  availability_zones = var.availability_zones
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.main.arn]
  termination_policies = ["OldestInstance"]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name}-scale-up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.name}_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  alarm_description = "High CPU alarm"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name}-scale-down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.name}_low_cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  alarm_description = "Low CPU alarm"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
