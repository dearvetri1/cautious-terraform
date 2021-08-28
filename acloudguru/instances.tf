data "aws_ssm_parameter" "linux-ami" {
  provider = aws.region-master
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "linux-ami-oregon" {
  provider = aws.region-worker
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "master-key" {
  provider = aws.region-master
  public_key = "${file("ec2key.pub")}"
  key_name = "jenkins"
}

resource "aws_key_pair" "worker-key" {
  provider = aws.region-worker
  public_key = "${file("ec2key.pub")}"
  key_name = "jenkins"
}

resource "aws_instance" "jenkins-master" {
  provider = aws.region-master
  ami = "${data.aws_ssm_parameter.linux-ami.value}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.master-key.key_name}"
  subnet_id = "${aws_subnet.subnet-1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.jenkins-master-sg.id}"]
  tags = {
    Name = "jenkins-master-ec2"
  }

  depends_on = [
    aws_main_route_table_association.internet-main-route-table-assc]
}

resource "aws_instance" "jenkins-worker-oregon" {
  count = 2
  provider = aws.region-worker
  ami = "${data.aws_ssm_parameter.linux-ami-oregon.value}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.worker-key.key_name}"
  subnet_id = "${aws_subnet.subnet-1-oregon.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.jenkins-worker-sg.id}"]

  tags = {
    Name = "${join("-", ["jenkins-worker-ec2", count.index + 1])}"
  }

  depends_on = [
    aws_main_route_table_association.internet-main-route-table-assc-oregon,
    aws_instance.jenkins-master]
}