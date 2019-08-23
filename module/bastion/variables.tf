# https://wiki.ubuntu.com/Minimal
variable "ami" {
  description = "Map of Ubuntu Minimal AMIs by region"
  type        = "map"

  default = {
    us-east-1 = "ami-7029320f"
    us-east-2 = "ami-0350efe0754b8e179"
    us-west-1 = "ami-657f9006"
    us-west-2 = "ami-59694f21"
  }
}

variable "instances" {
  type        = "string"
  description = "The number of bastion host(s)"

  default = 1
}

variable "instance-type" {
  type        = "string"
  description = "Bastion host instance type"

  default = "t3.micro"
}

variable "ssh-key" {
  type        = "string"
  description = "The SSH key for connecting to bastion host(s)"
}

variable "root-volume-size" {
  type        = "string"
  description = "The root volume size"

  default = 60
}

variable "vpc" {
  type        = "string"
  description = "The VPC name"
}
