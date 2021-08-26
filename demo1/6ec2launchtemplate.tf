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

  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "Vpground instace 1 sg"
  }
}
resource "aws_iam_role" "dev-ssm-iam-role" {
  name = "dev-ssm-iam-role"
  assume_role_policy = jsonencode(
  {
  Version = "2012-10-17"
  Statement = [
  {
  Action = "sts:AssumeRole"
  Effect = "Allow"
  Sid = ""
  Principal = {
  Service = "ec2.amazonaws.com"
  }
  },
  ]
  }
  )
  tags = {
    Name = "VPG SSM IAM Role"
  }
}

resource "aws_iam_instance_profile" "ssm-instance-profile" {
  name = "VPG-SSM-instance-profile"
  role = "${aws_iam_role.dev-ssm-iam-role.id}"
}

resource "aws_iam_role_policy_attachment" "dev-ssm-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = "${aws_iam_role.dev-ssm-iam-role.id}"
}

resource "aws_iam_role_policy_attachment" "dev-ssm-policy-2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role = "${aws_iam_role.dev-ssm-iam-role.id}"
}


resource "aws_launch_template" "simple-ec2" {
  name = "template-simple"
  image_id = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  monitoring {
    enabled = true
  }
  iam_instance_profile {
    arn = "${aws_iam_instance_profile.ssm-instance-profile.arn}"
  }
  network_interfaces {
    subnet_id = "${module.main-public-1.subnet_id}"
    security_groups = [
      "${aws_security_group.instance1-sg.id}"]
  }

  key_name = "${aws_key_pair.ec2instance1-key.key_name}"
}
