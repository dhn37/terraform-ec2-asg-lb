module "asg" {
  source = "../terraform-ec2-asg-lb"  # or GitHub URL

  name                     = "alb-deployment"
  intended_access_protocol = "HTTP"
  ami_id                   = "ami-xxxxxxxxxxxxxxxxx"
  instance_type            = "t3.micro"
  availability_zones       = ["us-west-2a", "us-west-2b"]      # you can select your own regions
  vpc_id                   = "vpc-xxxxxxxxxxxxxxxxx"
  lb_subnets               = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]
# lb_port                  = 443    # NLB will listen on 443

  security_group_ids       = ["sg-xxxxxxxxxxxxxxxxx"]      # EC2 SG
# alb_security_group_ids   = ["sg-xxxxxxxxxxxxxxxxx"]      # ALB SG
  
  user_data                = file("setup.sh")
  scale_up_adjustment      = 2
  scale_down_adjustment    = -1

  desired_capacity         = 1
  min_size                 = 1
  max_size                 = 2
  scale_up_threshold       = 70
  scale_down_threshold     = 20
}
