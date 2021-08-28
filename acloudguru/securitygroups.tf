resource "aws_security_group" "alb_sg" {
  provider = aws.region-master
  name = "alb-sg"
  vpc_id = "${aws_vpc.vpc-master.id}"

  dynamic "ingress" {
    for_each = [
      80,
      443]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

#This is the security group for the ec2 instance in which jenkins will be configured
resource "aws_security_group" "jenkins-master-sg" {
  provider = aws.region-master
  name = "jenkins-master-sg"
  vpc_id = "${aws_vpc.vpc-master.id}"

  #Allow connection from ALB to this master jenkins sg which will be assigned to ec2instance in us-east-1 in subnet 1
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080

    #Here who can connect this security group via this port need not be a cidr block instead it should be the security group of alb
    security_groups = [
      "${aws_security_group.alb_sg.id}"]
  }

  #Allow inbound requests from subnet in which worker is installed in us-west-2 to master
  ingress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "${aws_subnet.subnet-1-oregon.cidr_block}"]
  }

  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-worker-sg" {
  provider = aws.region-worker
  name = "jenkins-worker-sg"
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"

  ingress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "${aws_subnet.subnet-1.cidr_block}"]
  }

  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}