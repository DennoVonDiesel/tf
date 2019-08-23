This is a module for bastion hosts in a VPC. Managed resources:

- EC2 instance(s) in the public subnet(s) of a VPC.
- Security group for bastion hosts to access local resources.

Bastion hosts are running Minimal Ubuntu for performance and security:
 
- https://blog.ubuntu.com/2018/07/09/minimal-ubuntu-released

Cloud-init is used to bootstrap the host:

- https://cloudinit.readthedocs.io/en/latest/
- Add tools for client access and debugging such as psql, nmap, aws, curl, etc.
- Enable automatic updates for security and critical updates.

Although in the public subnets for inbound ssh connections, the security group only allows access to the VPC (no egress Internet access) for security reasons.

The default login is: `ubuntu@[public ip|hostname]`

Required variables:

- vpc: The name of the vpc
- ssh-key: The ssh key for access to EC2 instance(s)

Example:

```
module "dev" {
  source = "git@github.com:DennoVonDiesel/tf/module/bastion" 

  vpc     = "dev"
  ssh-key = "bastion-dev"
}
```
