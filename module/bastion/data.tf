data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  tags {
    Name = "${var.vpc}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Tier = "Public"
  }
}
