resource "aws_autoscaling_group" "Vpground-asg" {
  max_size = 3
  min_size = 1
  availability_zones = [
    "us-east-1a"]
  launch_template {
    id = "${aws_launch_template.simple-ec2.id}"
    version = "$Latest"
  }
}