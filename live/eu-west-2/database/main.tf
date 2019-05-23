# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-2"
  version = "~> 2.11.0"
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.3"
  instance_class         = "db.t2.micro"
  name                   = "ursho_db"
  username               = "toto"
  password               = "azertyuiop"
  db_subnet_group_name   = "${aws_db_subnet_group.mainSubnet.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  skip_final_snapshot    = true
  port                   = "5432"

  tags = {
    Name = "instanceName"
  }
}

resource "aws_instance" "test-ec2-instance" {
  ami             = "ami-0e1a16be3904aeea0"
  instance_type   = "t2.micro"
  key_name        = "key1"
  security_groups = ["${aws_security_group.allow_tls.id}"]

  tags {
    Name = "packer-example 1558594491"
  }
  provisioner "file" {
    source      = "config.json"
    destination = "~"
  }


  subnet_id = "${aws_subnet.main.id}"
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.test-ec2-instance.id}"
  vpc      = true
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

resource "aws_vpc" "main" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "main" {
  availability_zone = "eu-west-2a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.20.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "second" {
  availability_zone = "eu-west-2b"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.20.2.0/24"

  tags = {
    Name = "subnet2"
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

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]

    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "mainSubnet" {
  name       = "main"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.second.id}"]

  tags = {
    Name = "db_subnet_group_name"
  }
}
