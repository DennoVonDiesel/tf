## Introduction

This is a Terraform module to quickly setup an AWS VPC in 10.x.0.0/16. It uses the Terraform Registry AWS VPC module:

https://registry.terraform.io/modules/terraform-aws-modules/vpc/

It creates subnets in 3 availability zones using the following tiers:

- Intra (/21): Resources that are available within the VPC and do not have egress Internet access (Databases, caches, etc.)
- Private (/18): Resources that are available only within the VPC; however, require egress Internet access via NAT gateway(s).
- Public (/21): Resources that are available on the Internet. They will be avaible on the Internet if assigned an Elastic IP (EIP)

Subnets are tagged so they can be used as a data resource for other modules:

```
data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.id

  tags = {
    Tier = "public"
  }
}
```

Subnets are tagged for use with EKS, specifically the AWS load balancer controller and Karpenter.

## Example Usage

```
module "vpc" {
  source = "github.com/DennoVonDiesel/tf//module/aws/vpc?ref=v0.1.0"
  environment   = "dev"
}
```

## Version History

v0.1.0: Initial release
v0.2.0: Update to latest VPC module and use cidrsubnet
v0.3.0: Add EKS support, outputs, and security groups

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_elasticache_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_ingress_rule.mysql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The 10.N.0.0/16 CIDR block of the network. | `number` | `0` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC, defaults to [environment] | `string` | `""` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Enagle single NAT gateway | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources | `map(any)` | `{}` | no |

## Outputs

No outputs.
