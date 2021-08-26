resource "aws_key_pair" "ec2instance1-key" {
  key_name = "ec2instance1"
  //public_key = file("${var.ec2instance1-public-key}")
  public_key = "${file(var.ec2instance1-public-key)}"
}