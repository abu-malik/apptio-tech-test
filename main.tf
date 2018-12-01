provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "apptio-test-vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "apptio-test-vpc"
  }
}

resource "aws_subnet" "apptio-test-public-subnet" {
  vpc_id            = "${aws_vpc.apptio-test-vpc.id}"
  cidr_block        = "${var.subnet-cidr-public}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags {
    Name = "apptio-test-public-subnet"
  }
}

resource "aws_route" "apptio-test-public-subnet-route" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.apptio-test-internet-gateway.id}"
  route_table_id          = "${aws_route_table.apptio-test-public-subnet-route-table.id}"
}

resource "aws_route_table_association" "public-subnet-route-table-association" {
  subnet_id      = "${aws_subnet.apptio-test-public-subnet.id}"
  route_table_id = "${aws_route_table.apptio-test-public-subnet-route-table.id}"
}

resource "aws_route_table" "apptio-test-public-subnet-route-table" {
  vpc_id = "${aws_vpc.apptio-test-vpc.id}"
  tags {
    Name = "apptio-test-public-subnet-route-table"
  }
}

resource "aws_internet_gateway" "apptio-test-internet-gateway" {
  vpc_id = "${aws_vpc.apptio-test-vpc.id}"
  tags {
    Name = "apptio-test-internet-gateway"
  }
}

resource "aws_s3_bucket" "eb_s3_app_bucket" {
  bucket = "apptio-web-app-versions"
  acl    = "private"
  tags {
    Name = "Apptio WebApp application version"
  }
}

resource "aws_elastic_beanstalk_application" "apptio_beanstalk_app" {
  name        = "apptio-web-app"
  description = "Apptio Beanstalk web application"
}

resource "aws_elastic_beanstalk_environment" "apptio_beanstalk_env" {
  name                = "apptio-web-app"
  application         = "${aws_elastic_beanstalk_application.apptio_beanstalk_app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.4 running PHP 7.2"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.apptio-test-vpc.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.apptio-test-public-subnet.id}"
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${var.eb_ec2_role}"
  }
}

resource "aws_security_group" "apptio-test-web-instance-security-group" {
  vpc_id      = "${aws_vpc.apptio-test-vpc.id}"

  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "apptio-test-web-instance-security-group"
  }
}
output "Application_URL" {
  value = "${aws_elastic_beanstalk_environment.apptio_beanstalk_env.cname}"
}