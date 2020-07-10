variable "vpc" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block of the VPC (10.NNN.0.0/16)"
  type        = number

  default = 10
}

variable "azs" {
  description = "Availability zones of the VPC (max 4)"
  type        = list(string)

  default = ["a", "b"]
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map

  default = {}
}
