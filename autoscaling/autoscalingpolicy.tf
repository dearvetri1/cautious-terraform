resource "aws_autoscaling_policy" "this" {
  autoscaling_group_name = "${aws_autoscaling_group.this-autoscaling.name}"
  name = "vpground-autoscaling-policy"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "this-scaledown" {
  autoscaling_group_name = "${aws_autoscaling_group.this-autoscaling.name}"
  name = "vpground-autoscaling-policy-scaledown"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  policy_type = "SimpleScaling"
}