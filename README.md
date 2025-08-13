# 🚀 EC2 Auto Scaling Group Terraform Module  

This Terraform module lets CTF authors easily deploy EC2-based challenges behind an Auto Scaling Group (ASG), optionally fronted by an ALB (for HTTP) or NLB (for TCP).  
It’s split into two parts:

```
📁 terraform-ec2-asg-lb/     --> The reusable Terraform module
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
├── terraform-ec2-asg-lb/
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
  source = "../terraform-ec2-asg-lb"

  name                     = "testlb"
  intended_access_protocol = "HTTP"             # Or "TCP"
  user_data                = file("setup.sh")

  ami_id           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type    = "t3.micro"
  availability_zones = ["us-west-2a"]
  vpc_id             = "vpc-xxxxxxxxxxxxxxxxx"
  lb_subnets         = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]
# lb_port            = 443    # While using NLB, mention port number otherwise default PORT:80
  security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]
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
cd test-alb OR cd test-nlb
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

See `terraform-ec2-asg-lb/variables.tf` for full list. Highlights:

| Variable                  | Description                                   |
|---------------------------|-----------------------------------------------|
| `intended_access_protocol`| "HTTP" (for ALB) or "TCP" (for NLB)           |
| `user_data`               | Startup script (e.g. `file("setup.sh")`)      |
| `lb_subnets`              | Subnets for LB (must be public)               |
| `lb_port`                 | Listener port for the load balancer. Default is 80 (HTTP). For NLB, set this to the desired TCP port (e.g., 443) |
| `security_group_ids`      | EC2 Security Group(s)                         |
| `alb_security_group_ids`  | (Optional) ALB security group IDs. If not provided, AWS uses the default VPC security group. Ignored for NLB  |


**Security Groups:**
- ALB: If `alb_security_group_ids` is not set, AWS attaches the default VPC SG. Make sure it allows inbound on the listener port.
- NLB: Does not support security groups. Ensure your EC2 SG allows inbound from the NLB on the listener port.


---

## 👤 Author  
- [Dhanush Nair](https://www.linkedin.com/in/dhn37/)
