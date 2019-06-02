provider "aws" {
  region  = "eu-west-2"
  version = "~> 2.11.0"
}

resource "aws_vpc" "main" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpcBastion"
  }
}

resource "aws_subnet" "main" {
  availability_zone = "eu-west-2a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.20.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  tags = {
    Name = "securityName"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test-ec2-instance" {
  ami             = "ami_id" //ici
  instance_type   = "t2.micro"
  key_name        = "key_name" //ici
  security_groups = ["${aws_security_group.allow_tls.id}"]

  tags {
    Name = "Bastion"
  }
}

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "test-env-gw"
  }
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }

  tags {
    Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}