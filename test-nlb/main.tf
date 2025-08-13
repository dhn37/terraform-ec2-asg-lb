module "nlb" {
  source = "../dc33-ec2-deployment"  # or GitHub URL

  name                     = "nlb-deployment"
  intended_access_protocol = "TCP"
  ami_id                   = "ami-xxxxxxxxxxxxxxxxx"
  instance_type            = "t3.micro"
  availability_zones       = ["us-west-2a", "us-west-2b"]
  vpc_id                   = "vpc-xxxxxxxxxxxxxxxxx"
  lb_subnets               = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]
  lb_port                  = 443    # NLB will listen on 443
  security_group_ids       = ["sg-xxxxxxxxxxxxxxxxx"]
  user_data                = file("setup.sh")
  scale_up_adjustment      = 2
  scale_down_adjustment    = -1

  desired_capacity         = 1
  min_size                 = 1
  max_size                 = 2
  scale_up_threshold       = 70
  scale_down_threshold     = 20
}
