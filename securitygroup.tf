

data "aws_ip_ranges" "us-east-1-ec2" {
  services = ["ec2"]
  regions  = ["us-east-1"]
}

output "ips" {
  value = "${data.aws_ip_ranges.us-east-1-ec2.cidr_blocks}"
}

resource "aws_security_group" "from_us_east-1_sg" {
  name = "from_us_east-1_sg"

  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
  }
}
