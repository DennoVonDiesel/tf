output "id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "intra_subnets" {
  description = "The intranet subnet IDs"
  value       = module.vpc.intra_subnets
}

output "private_subnets" {
  description = "The private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The public subnet IDs"
  value       = module.vpc.public_subnets
}

output "db_subnet_group" {
  description = "The default database subnet group name"
  value       = aws_db_subnet_group.default.id
}

output "db_security_group" {
  description = "The database security group ID"
  value       = aws_security_group.db.id
}

output "elasticache_subnet_group" {
  description = "The default ElastiCache subnet group name"
  value       = aws_elasticache_subnet_group.default.id
}

output "elasticache_security_group" {
  description = "The ElastiCache security group ID"
  value       = aws_security_group.elasticache.id
}
