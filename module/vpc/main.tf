resource "aws_vpc" "this" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = "${var.enable-dns-support}"
  enable_dns_hostnames = "${var.enable-dns-hostnames}"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = "${aws_vpc.this.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  lifecycle {
    ignore_changes = ["subnet_ids"]
  }

  tags {
    Name = "${var.name}"
  }
}

# DHCP Option Sets
resource "aws_vpc_dhcp_options" "this" {
  domain_name         = "${var.domain-name}"
  domain_name_servers = "${var.domain-name-servers}"
  ntp_servers         = "${var.ntp-servers}"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = "${aws_vpc.this.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.this.id}"
}

# EIPs (for NAT Gateways)
resource "aws_eip" "private" {
  count = "${length(var.az)}"

  vpc        = true
  depends_on = ["aws_internet_gateway.this"]
}

# Internet Gateways
resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.name}"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "private" {
  count = "${length(var.az)}"

  allocation_id = "${element(aws_eip.private.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

# Route Tables
# Public
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "public" {
  count = "${length(var.az)}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.az)}"

  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}

# Private
resource "aws_route_table" "private" {
  count  = "${length(var.az)}"
  vpc_id = "${aws_vpc.this.id}"

  tags {
    Name = "${format("%s-private-%s%s", 
      var.name, 
      var.region2abbr[data.aws_region.current.name], 
      element(var.az, count.index)
    )}"
  }
}

resource "aws_route" "private-nat-gw" {
  count = "${length(var.az)}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.private.*.id, count.index)}"
}

resource "aws_route_table_association" "private-nat-gw" {
  count = "${length(var.az)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# Subnets
resource "aws_subnet" "intra" {
  count = "${length(var.az)}"

  vpc_id = "${aws_vpc.this.id}"

  availability_zone = "${format("%s%s", data.aws_region.current.name, element(var.az, count.index))}"
  cidr_block        = "${element(var.db-subnet-cidr, count.index)}"

  tags = {
    Name = "${format("%s-intra-%s%s", 
      var.name, 
      var.region2abbr[data.aws_region.current.name],
      element(var.az, count.index)
    )}"

    Tier = "Database"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}"
  subnet_ids = ["${aws_subnet.intranet.*.id}"]

  tags {
    Name = "${var.name}"
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}"
  subnet_ids = ["${aws_subnet.intranet.*.id}"]

  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.az)}"

  vpc_id = "${aws_vpc.this.id}"

  availability_zone = "${format("%s%s", data.aws_region.current.name, element(var.az, count.index))}"
  cidr_block        = "${element(var.private-subnet-cidr, count.index)}"

  tags = {
    Name = "${format("%s-private-%s%s", 
      var.name, 
      var.region2abbr[data.aws_region.current.name],
      element(var.az, count.index)
    )}"

    Tier = "Private"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.az)}"

  vpc_id = "${aws_vpc.this.id}"

  availability_zone = "${format("%s%s", data.aws_region.current.name, element(var.az, count.index))}"
  cidr_block        = "${element(var.public-subnet-cidr, count.index)}"

  tags = {
    Name = "${format("%s-public-%s%s", 
      var.name, 
      var.region2abbr[data.aws_region.current.name],
      element(var.az, count.index))
    }"

    Tier = "Public"
  }
}

# VPC endpoints
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.this.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private-s3" {
  count = "${length(var.az)}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "public-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.public.id}"
}
