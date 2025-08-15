# 🚀 EC2 Auto Scaling Group Terraform Module  

This Terraform module lets CTF authors easily deploy EC2-based challenges behind an Auto Scaling Group (ASG), optionally fronted by an ALB (for HTTP) or NLB (for TCP).  
It’s split into two parts:

```
📁 terraform-ec2-asg-lb/     --> The reusable Terraform module
📁 test-alb/                --> A sample project that calls the alb module
📁 test-nlb/                --> A sample project that calls the nlb module
```

---

##  Features

- Automatic launch template generation
- Autoscaling based on CPU usage
- Load balancer (ALB or NLB) based on protocol
- Easy user_data injection
- Clean separation of module + usage

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
  source = "git::https://github.com/dhn37/terraform-ec2-asg-lb.git//terraform-ec2-asg-lb"

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

## Outputs

After deployment, you’ll see:

| Output                   | Description                                  |
|--------------------------|----------------------------------------------|
| `load_balancer_dns`      | Public DNS name of the ALB/NLB               |
| `autoscaling_group_name` | Name of the Auto Scaling Group               |
| `launch_template_id`     | Launch Template used in ASG                  |
| `load_balancer_type`     | "application" for ALB or "network" for NLB   |

---

## Module Inputs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.high_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.low_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_ids"></a> [alb\_security\_group\_ids](#input\_alb\_security\_group\_ids) | List of security group IDs to attach to the ALB. If not specified, AWS will use the default VPC SG. | `list(string)` | `null` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use in EC2 | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of AZs | `list(string)` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired number of EC2 instances | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | n/a | yes |
| <a name="input_intended_access_protocol"></a> [intended\_access\_protocol](#input\_intended\_access\_protocol) | HTTP or TCP — determines LB protocol | `string` | n/a | yes |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | Port the LB listens on | `number` | `80` | no |
| <a name="input_lb_subnets"></a> [lb\_subnets](#input\_lb\_subnets) | Subnets for Load Balancer | `list(string)` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of instances | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of instances | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Prefix for naming resources | `string` | n/a | yes |
| <a name="input_scale_down_adjustment"></a> [scale\_down\_adjustment](#input\_scale\_down\_adjustment) | Number of instances to scale down by | `number` | `-1` | no |
| <a name="input_scale_down_threshold"></a> [scale\_down\_threshold](#input\_scale\_down\_threshold) | CPU % threshold to scale down | `number` | `20` | no |
| <a name="input_scale_up_adjustment"></a> [scale\_up\_adjustment](#input\_scale\_up\_adjustment) | Number of instances to scale up by | `number` | `2` | no |
| <a name="input_scale_up_threshold"></a> [scale\_up\_threshold](#input\_scale\_up\_threshold) | CPU % threshold to scale up | `number` | `70` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups for EC2 | `list(string)` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Path to data script for EC2 instance | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where ASG and LB should run | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_group_name"></a> [autoscaling\_group\_name](#output\_autoscaling\_group\_name) | Name of the Auto Scaling Group |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | Launch Template ID |
| <a name="output_load_balancer_dns"></a> [load\_balancer\_dns](#output\_load\_balancer\_dns) | DNS name of the Load Balancer |
| <a name="output_load_balancer_type"></a> [load\_balancer\_type](#output\_load\_balancer\_type) | Type of Load Balancer (application or network) |
<!-- END_TF_DOCS -->

See [`terraform-ec2-asg-lb/variables.tf`](terraform-ec2-asg-lb/variables.tf) for full list. Highlights:

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

## Author  
- [Dhanush Nair](https://www.linkedin.com/in/dhn37/)
