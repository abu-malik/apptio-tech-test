variable "region" {
  default = "eu-west-1"
}

variable "vpc-cidr" {}

variable "subnet-cidr-public" {}

variable "eb_ec2_role" {
   description = "IAM role"
   default     = "aws-elasticbeanstalk-ec2-role"
}