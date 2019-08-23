resource "aws_security_group" "bastion" {
  vpc_id = "${data.aws_vpc.vpc.id}"
  name   = "bastion-${var.vpc}"

  tags {
    Name        = "bastion-${var.vpc}"
    Environment = "${var.vpc}"
    Service     = "bastion"
  }
}

resource "aws_security_group_rule" "bastion-ingress-ssh" {
  security_group_id = "${aws_security_group.bastion.id}"

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-egress-vpc" {
  security_group_id = "${aws_security_group.bastion.id}"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1

  cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]
}

# APT
resource "aws_security_group_rule" "bastion-egress-http" {
  security_group_id = "${aws_security_group.bastion.id}"

  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}
