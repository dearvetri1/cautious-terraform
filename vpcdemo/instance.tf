resource "aws_instance" "example" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.main-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  key_name = "${aws_key_pair.mykey.key_name}"
}

resource "aws_eip" "example-eip" {
  vpc = true
  instance = "${aws_instance.example.id}"
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "${aws_subnet.main-public-1.availability_zone}"
  size = 20
  type = "gp2"
  tags = {
    Name = "Extra volume data"
  }
}

resource "aws_volume_attachment" "ebs-voume-1-attachment" {
  device_name = "/dev/xvdh"
  instance_id = "${aws_instance.example.id}"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  force_detach = true
}


output "example-public-ip" {
  value = "${aws_instance.example.public_ip}"
}

resource "aws_route53_zone" "vetrisplayground-com" {
  name = "vetrisplayground.com"
}

resource "aws_route53_record" "www" {
  name = "${aws_route53_zone.vetrisplayground-com.name}"
  type = "A"
  zone_id = "${aws_route53_zone.vetrisplayground-com.zone_id}"
  records = ["${aws_eip.example-eip.public_ip}"]
  ttl = 300
}

resource "aws_s3_bucket" "vetrisplayground-s3" {
  bucket = "vetrisplayground.com"
  acl = "public-read"
  policy = "${data.aws_iam_policy_document.website_policy.json}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

output "name-servers" {
  value = "${aws_route53_zone.vetrisplayground-com.name_servers}"
}