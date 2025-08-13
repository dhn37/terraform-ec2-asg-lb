variable "name" {
  description = "Prefix for naming resources"
  type        = string
}

variable "intended_access_protocol" {
  description = "HTTP or TCP — determines LB protocol"
  type        = string
  validation {
    condition     = contains(["HTTP", "TCP"], var.intended_access_protocol)
    error_message = "Protocol must be HTTP or TCP."
  }
}

variable "user_data" {
  description = "Path to data script for EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use in EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where ASG and LB should run"
  type        = string
}

variable "lb_subnets" {
  description = "Subnets for Load Balancer"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for EC2"
  type        = list(string)
}

variable "lb_port" {
  description = "Port the LB listens on"
  type        = number
  default     = 80
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "scale_up_threshold" {
  description = "CPU % threshold to scale up"
  type        = number
  default     = 70
}

variable "scale_down_threshold" {
  description = "CPU % threshold to scale down"
  type        = number
  default     = 20
}

variable "scale_up_adjustment" {
  description = "Number of instances to scale up by"
  type        = number
  default     = 2
}

variable "scale_down_adjustment" {
  description = "Number of instances to scale down by"
  type        = number
  default     = -1
}

variable "alb_security_group_ids" {
  description = "List of security group IDs to attach to the ALB. If not specified, AWS will use the default VPC SG."
  type        = list(string)
  default     = null
}