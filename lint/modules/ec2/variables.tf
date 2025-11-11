variable "ami" {
  description = "AMI for Ubuntu EC2 instance"
  type        = string
  default     = "ami-046c2381f11878233"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}