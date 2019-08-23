This is a module to create a VPC. Managed resources:

- Default network ACL
- DHCP option set (uses AWS provided DNS servers)
- Subnets for private, public, and local
- NAT gateways for private subnets to have egress access to the Internet
- VPC endpoint for S3

Subnet specifications:

- Public: Resources that are available on the Internet. They will be avaible on the Internet if assigned an Elastic IP (EIP)
- Private: Resources that are available only within the VPC; however, require egres Internet access via NAT gateway(s).
- Local: Resources that are available within the VPC and do not have egress Internet access (Databases, caches, etc.)

Required variables:

- name: The namep of the VPC
- cidr: The CIDR block of the VPC
- az: The availability zones to use
- private-subnet-cidr: The private subnet CIDR blocks to use for the availability zones
- public-subnet-cidr: The public subnet CIDR blocks to use for the availability zones
- local-subnet-cidr: The intra subnet CIDR blocks to use for the availability zones

Example:

```
module "dev" {
  source = "git@github.com:DennoVonDiesel/tf/module/vpc"

  name = "dev"
  cidr = "172.28.0.0/16"

  az                  = ["a", "b"]
  private-subnet-cidr = ["172.28.0.0/20", "172.28.16.0/20"]    # 32, 48 for future use
  public-subnet-cidr  = ["172.28.64.0/20", "172.28.80.0/20"]   # 96, 112 for future use
  local-subnet-cidr   = ["172.28.128.0/20", "172.28.144.0/20"] # 160, 175 for future use 
}
```
