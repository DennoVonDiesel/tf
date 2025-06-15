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
