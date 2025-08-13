# 🚀 EC2 Auto Scaling Group Terraform Module  

This Terraform module lets CTF authors easily deploy EC2-based challenges behind an Auto Scaling Group (ASG), optionally fronted by an ALB (for HTTP) or NLB (for TCP).  
It’s split into two parts:

```
📁 dc33-ec2-asg-module/     --> The reusable Terraform module
📁 test-alb/                --> A sample project that calls the alb module
📁 test-nlb/                --> A sample project that calls the nlb module
```

---

## 📦 Features

- ✅ Automatic launch template generation
- ✅ Autoscaling based on CPU usage
- ✅ Load balancer (ALB or NLB) based on protocol
- ✅ Easy user_data injection
- ✅ Clean separation of module + usage

---

## 🗂 Folder Structure

```
.
├── dc33-ec2-asg-module/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│
├── test-alb/
│   ├── main.tf       # Uses the module for alb
│   ├── outputs.tf
│   └── setup.sh      # Example user_data for alb
│
├── test-nlb/
│   ├── main.tf       # Uses the module for nlb
│   ├── outputs.tf
│   └── setup.sh      # Example user_data for nlb
```

---

## 🛠 How to Use

In your Terraform root (`test-alb/` or `test-nlb/`):

```hcl
module "asg" {
  source = "../dc33-ec2-asg-module"

  name                     = "ctf-challenge-1"
  intended_access_protocol = "HTTP"             # Or "TCP"
  user_data                = file("setup.sh")

  ami_id           = "ami-0abc123456789xyz"
  instance_type    = "t3.micro"
  availability_zones = ["us-west-2a"]
  vpc_id             = "vpc-0123456789abcdef0"
  lb_subnets         = ["subnet-123", "subnet-456"]
# lb_port            = 443    # While using NLB, mention port number otherwise default PORT:80
  security_group_ids = ["sg-0123abcd"]
  scale_up_adjustment      = 2
  scale_down_adjustment    = -1

  desired_capacity     = 1
  min_size             = 1
  max_size             = 2
  scale_up_threshold   = 70
  scale_down_threshold = 20
}
```

Then run:
```bash
cd test-alb OR cd test=nlb
terraform init
terraform apply
```

---

## 📤 Outputs

After deployment, you’ll see:

| Output                   | Description                                  |
|--------------------------|----------------------------------------------|
| `load_balancer_dns`      | Public DNS name of the ALB/NLB               |
| `autoscaling_group_name` | Name of the Auto Scaling Group               |
| `launch_template_id`     | Launch Template used in ASG                  |
| `load_balancer_type`     | "application" for ALB or "network" for NLB   |

---

## 🧾 Module Inputs

See `dc33-ec2-asg-module/variables.tf` for full list. Highlights:

| Variable                  | Description                                   |
|---------------------------|-----------------------------------------------|
| `intended_access_protocol`| "HTTP" (for ALB) or "TCP" (for NLB)           |
| `user_data`               | Startup script (e.g. `file("setup.sh")`)      |
| `lb_subnets`              | Subnets for LB (must be public)               |
| `lb_port`                 | Default is 80, can be changed for NLB         |
| `security_group_ids`      | EC2 Security Group(s)                         |

---

## 👤 Author  
- [Dhanush Nair](https://www.linkedin.com/in/dhn37/)
