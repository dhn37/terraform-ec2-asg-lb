run "plan_alb" {
  command = plan

  # Variables passed to your example root module
  variables {
    name                     = "test-alb"
    intended_access_protocol = "HTTP"               # should produce ALB
    ami_id                   = "ami-0123456789abcdef0"
    instance_type            = "t3.micro"
    availability_zones       = ["us-west-2a"]
    vpc_id                   = "vpc-aaaaaaaa"
    lb_subnets               = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
    security_group_ids       = ["sg-aaaaaaaa"]
    user_data                = "echo hi"
    # lb_port default 80 is fine for ALB
  }

  assert {
    condition     = output.load_balancer_type == "application"
    error_message = "Expected ALB (application) when intended_access_protocol = HTTP"
  }

  assert {
    condition     = output.autoscaling_group_name != ""
    error_message = "autoscaling_group_name output should not be empty"
  }
}
