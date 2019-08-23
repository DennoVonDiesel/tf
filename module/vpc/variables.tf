variable "name" {
  type        = "string"
  description = "VPC name"
}

variable "cidr" {
  type        = "string"
  description = "VPC CIDR Block"
}

# DNS settings
variable "enable-dns-support" {
  type        = "string"
  description = "Enable DNS support"

  default = true
}

variable "enable-dns-hostnames" {
  type        = "string"
  description = "Enable DNS hostnames"

  default = true
}

variable "domain-name" {
  type        = "string"
  description = "DNS domain name"

  default = "ec2.internal"
}

variable "domain-name-servers" {
  type        = "list"
  description = "DNS domain name servers"

  default = ["AmazonProvidedDNS"]
}

variable "ntp-servers" {
  type        = "list"
  description = "NTP servers"

  default = ["127.0.0.1"]
}

# Subnets
variable "az" {
  type        = "list"
  description = "List of Availability Zones"
}

variable "db-subnet-cidr" {
  type        = "list"
  description = "List of database CIDR blocks (mapping to azs)"
}

variable "private-subnet-cidr" {
  type        = "list"
  description = "List of private CIDR blocks (mapping to azs)"
}

variable "public-subnet-cidr" {
  type        = "list"
  description = "List of public CIDR blocks (mapping to azs)"
}

variable "region2abbr" {
  type        = "map"
  description = "AWS region abbreviation"

  default = {
    us-east-1 = "use1"
    us-east-2 = "use2"
    us-west-1 = "usw1"
    us-west-2 = "usw2"
  }
}
