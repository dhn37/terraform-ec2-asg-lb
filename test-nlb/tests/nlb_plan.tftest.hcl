run "plan_nlb" {
  command = plan

  variables {
    name                     = "test-nlb"
    intended_access_protocol = "TCP"                # should produce NLB
    ami_id                   = "ami-0123456789abcdef0"
    instance_type            = "t3.micro"
    availability_zones       = ["us-west-2a"]
    vpc_id                   = "vpc-bbbbbbbb"
    lb_subnets               = ["subnet-cccccccc", "subnet-dddddddd"]
    lb_port                  = 443
    security_group_ids       = ["sg-bbbbbbbb"]
    user_data                = "echo hi"
  }

  assert {
    condition     = output.load_balancer_type == "network"
    error_message = "Expected NLB (network) when intended_access_protocol = TCP"
  }

  assert {
    condition     = output.autoscaling_group_name != ""
    error_message = "autoscaling_group_name output should not be empty"
  }
}
