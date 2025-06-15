data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = var.name != "" ? var.name : var.environment
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr = format("10.%s.0.0/16", var.cidr)

  # /21 for 0, 8, 16
  intra_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 5, k)]
  # /21 for 24, 32, 40
  public_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 5, k + 3)]
  # /18 for 64, 128, 192
  private_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 2, k + 1)]

  tags = {
    Environment = var.environment
    Region      = data.aws_region.current.name
    Service     = "vpc"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5"

  name = local.name

  cidr            = local.cidr
  azs             = local.azs
  intra_subnets   = local.intra_subnets
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway

  intra_subnet_tags = {
    Tier = "intra"
  }
  private_subnet_tags = {
    Tier                              = "private"
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = local.name
  }
  public_subnet_tags = {
    Tier                     = "public"
    "kubernetes.io/role/elb" = 1

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

  tags = merge(local.tags, var.tags)
}

# Datastores use Intranet subnets
resource "aws_db_subnet_group" "default" {
  name       = format("%s-default", local.name)
  subnet_ids = module.vpc.intra_subnets

  tags = merge(
    {
      Name = format("%s-default", local.name)
    },
    local.tags,
    var.tags
  )
}

resource "aws_elasticache_subnet_group" "default" {
  name       = format("%s-default", local.name)
  subnet_ids = module.vpc.intra_subnets

  tags = merge(
    {
      Name = format("%s-default", local.name)
    },
    local.tags,
    var.tags
  )
}

# Security groups
resource "aws_security_group" "db" {
  name        = format("%s-db", module.vpc.name)
  description = "Allow VPC access to RDS"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    {
      Name = format("%s-db", module.vpc.name)
    },
    local.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.db.id
  description       = "Allow VPC access to MySQL"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_ipv4         = module.vpc.vpc_cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "postgresql" {
  security_group_id = aws_security_group.db.id
  description       = "Allow VPC access to PostgreSQL"
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_ipv4         = module.vpc.vpc_cidr_block
}

resource "aws_security_group" "elasticache" {
  name        = format("%s-elasticache", module.vpc.name)
  description = "Allow VPC access to ElastiCache"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    {
      Name = format("%s-elasticache", module.vpc.name)
    },
    local.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_security_group.elasticache.id
  description       = "Allow VPC access to Redis"
  ip_protocol       = "tcp"
  from_port         = 6379
  to_port           = 6379
  cidr_ipv4         = module.vpc.vpc_cidr_block
}
