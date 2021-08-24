module "common-vpc" {
  source = "../modules/common/vpc"
}

module "common-enable-ssh-security-group" {
  source = "../modules/common/security-group"
  vpc_id = "${module.common-vpc.this_vpc_id}"
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

module "main-public-1" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.1.0/24"
  az = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "vetrisplayground-public-subnet - 1"
  }
}

module "main-public-2" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.2.0/24"
  az = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "vetrisplayground-public-subnet - 2"
  }
}

resource "aws_launch_configuration" "this" {
  name = "webserver-launch-config"
  image_id = "ami-0133407e358cc1af0"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
  security_groups = ["${module.common-enable-ssh-security-group.allow-ssh-id}"]
}

resource "aws_autoscaling_group" "this-autoscaling" {
  max_size = 2
  min_size = 1
  name = "this-autoscaling"
  vpc_zone_identifier = ["${module.main-public-1.subnet_id}"]
  launch_configuration = "${aws_launch_configuration.this.name}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "ec2 instance"
  }
}

