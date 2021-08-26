resource "aws_security_group" "alb-security-group" {
  vpc_id = "${module.common-vpc.this_vpc_id}"
  name = "ALB Security Group"
  description = "Terraform ALB security group"
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["${module.common-vpc.this_vpc_cidr_block}"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["${module.common-vpc.this_vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    protocol = -1
    to_port = 0
  }

  tags = {
    Name = "Terraform ALB security group"
  }

}
#Create an ALB
resource "aws_alb" "this" {
  name = "Vpground-Application-ALB"
  internal = true
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  subnets = ["${module.main-public-1.subnet_id}", "${module.main-public-2.subnet_id}"]
  security_groups = ["${aws_security_group.alb-security-group.id}"]
}

#Create a target group
resource "aws_alb_target_group" "this-targetgroup" {
  name = "Vpground-ALB-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = "${module.common-vpc.this_vpc_id}"
}

#Add a listener. These are listening for any incoming connections to the load balancer in a given port and protocol and then redirector forward that request to a target group.
resource "aws_alb_listener" "this-alblistener" {
  load_balancer_arn = "${aws_alb.this.arn}"
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.this-targetgroup.arn}"
  }
}