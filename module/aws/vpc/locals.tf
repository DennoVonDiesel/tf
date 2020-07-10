locals {
  public_subnets = list(
    format("10.%s.0.0/20", var.cidr),
    format("10.%s.16.0/20", var.cidr),
    format("10.%s.32.0/20", var.cidr),
    format("10.%s.48.0/20", var.cidr),
  )

  private_subnets = list(
    format("10.%s.64.0/20", var.cidr),
    format("10.%s.80.0/20", var.cidr),
    format("10.%s.96.0/20", var.cidr),
    format("10.%s.112.0/20", var.cidr),

  )

  intra_subnets = list(
    format("10.%s.128.0/20", var.cidr),
    format("10.%s.144.0/20", var.cidr),
    format("10.%s.160.0/20", var.cidr),
    format("10.%s.176.0/20", var.cidr),
  )
}
