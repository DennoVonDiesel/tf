This is a Terraform 0.12 module to quickly setup an AWS VPC in 10.x.0.0/16. It uses the Terraform Registry AWS VPC module: 

https://registry.terraform.io/modules/terraform-aws-modules/vpc/

Individual subnets use a /20 subnet mask and use the following tiers:

- Public: Resources that are available on the Internet. They will be avaible on the Internet if assigned an Elastic IP (EIP)
- Private: Resources that are available only within the VPC; however, require egress Internet access via NAT gateway(s).
- Local: Resources that are available within the VPC and do not have egress Internet access (Databases, caches, etc.)

Subnets are tagged so they can be used as a data resource for other modules:

```
data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc
  }


data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "public"
  }
}
```

See https://www.terraform.io/docs/providers/aws/d/subnet_ids.html for more information.

Example Usage

```
module "dev" {
  source = "git@github.com:DennoVonDiesel/tf/module/aws/vpc"

  name = "dev"
  azs  = ["a", "b"]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azs | Availability zones of the VPC (max 4) | `list(string)` | <pre>[<br>  "a",<br>  "b"<br>]</pre> | no |
| cidr | CIDR block of the VPC (10.NNN.0.0/16) | `number` | `10` | no |
| tags | Tags applied to all resources | `map` | `{}` | no |
| vpc | Name of the VPC | `string` | n/a | yes |

## Outputs

No output.
