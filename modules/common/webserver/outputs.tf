output "instance_id" {
  description = "The ID of this ec2 instance"
  value = "${aws_instance.this.id}"
}
