variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "cidr" {
  description = "The 10.N.0.0/16 CIDR block of the network."
  type        = number

  default = 0
}

variable "name" {
  description = "The name of the VPC, defaults to [environment]"
  type        = string

  default = ""
}

variable "single_nat_gateway" {
  description = "Enagle single NAT gateway"
  type        = bool

  default = true
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(any)

  default = {}
}
