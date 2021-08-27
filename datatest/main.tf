//Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-0443305dabd4be2bc (64-bit x86) / ami-0806cc3ac66515671 (64-bit Arm)
data "aws_ami" "test" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.20210721.2-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

output "amiid" {
  value = "${data.aws_ami.test.id}"
}