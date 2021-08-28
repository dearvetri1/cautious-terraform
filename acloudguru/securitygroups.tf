resource "aws_security_group" "alb_sg" {
  provider = aws.region-master
  name = "alb-sg"
  vpc_id = "${aws_vpc.vpc-master.id}"

  dynamic "ingress" {
    for_each = [
      80,
      443,
      22]
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

#This is the security group for the ec2 instance in which jenkins will be configured. This security group will be attached to the vpc and not to the EC2 directly
#To put it simply, EC2 security groups are for the particular EC2 instances which you have attached them to. But you can also attach the EC2 security groups to VPC.
#On the other hand, a VPC security group can be only within the VPC. For example, if you have 2 VPCs under your account, the security group of the first VPC cannot be used in the second VPC. Under the VPC, you can apply the security group to any service (EC2, RDS).
#If your account was created before 2013, then you would have come across EC2-classic and this is not available now. In EC2-classic, you don't need to launch the instances under a VPC so they had a separate security group. But if you are a new AWS user, then every resource should be launched within a VPC, thus making the security group a single entity.
resource "aws_security_group" "jenkins-master-sg" {
  provider = aws.region-master
  name = "jenkins-master-sg"
  vpc_id = "${aws_vpc.vpc-master.id}"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

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