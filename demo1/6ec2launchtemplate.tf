#First create as many security groups as number of ec2 inctances planned to be launched
resource "aws_security_group" "instance1-sg" {
  vpc_id = "${module.common-vpc.this_vpc_id}"
  name = "Vpground instace 1 sg"
  description = "VPG SG for instance 1"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "Vpground instace 1 sg"
  }
}


resource "aws_launch_template" "simple-ec2" {
  name_prefix = "template-simple"
  image_id = "ami-0133407e358cc1af0"
  instance_type = "t2.micro"
  network_interfaces {
    subnet_id = "${module.main-public-1.subnet_id}"
    security_groups = [
      "${aws_security_group.instance1-sg.id}"]
  }
  key_name = "${aws_key_pair.ec2instance1-key.key_name}"
}
