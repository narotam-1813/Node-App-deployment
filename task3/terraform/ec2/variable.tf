variable "subnet_id" {
  description = "list of subnet id for ec2 launch"
  type = string
}

variable "ami_id" {
  description = "Ami ID for the instance"
  type = string
}

variable "vpc_id" {
  description = "VPC id for the instance"
}