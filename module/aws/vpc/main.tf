module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name = var.vpc

  azs             = formatlist("%s%s", data.aws_region.current.name, var.azs)
  cidr            = format("10.%s.0.0/16", var.cidr)
  public_subnets  = slice(local.public_subnets, 0, length(var.azs))
  private_subnets = slice(local.private_subnets, 0, length(var.azs))
  intra_subnets   = slice(local.intra_subnets, 0, length(var.azs))

  enable_dns_hostnames = true
  enable_nat_gateway   = true

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  intra_subnet_tags = {
    Tier = "intra"
  }

  public_route_table_tags = {
    Tier = "public"
  }

  private_route_table_tags = {
    Tier = "private"
  }

  intra_route_table_tags = {
    Tier = "intra"
  }

  tags = var.tags
}

# Datastores use Intranet subnets
resource "aws_db_subnet_group" "default" {
  name       = format("%s-default", var.vpc)
  subnet_ids = module.vpc.intra_subnets

  tags = merge(
    {
      Name = format("%s-default", var.vpc)
    },
    var.tags
  )
}

resource "aws_elasticache_subnet_group" "default" {
  name       = format("%s-default", var.vpc)
  subnet_ids = module.vpc.intra_subnets
}
