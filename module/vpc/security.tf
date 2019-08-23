resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow inbound ssh"

  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh"
  }
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow inbound HTTP"

  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "http"
  }
}

resource "aws_security_group" "https" {
  name        = "https"
  description = "Allow inbound HTTPS"

  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "https"
  }
}

resource "aws_security_group" "http-https" {
  name        = "http-https"
  description = "Allow inbound HTTP/HTTPS"

  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "http-https"
  }
}

resource "aws_security_group" "postgresql" {
  name        = "postgresql"
  description = "Allow inbound PostgreSQL"

  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "postgresql"
  }
}
