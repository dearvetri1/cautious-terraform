variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "ec2instance1-private-key" {
  default = "ec2instance1"
}

variable "ec2instance1-public-key" {
  default = "ec2instance1.pub"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
