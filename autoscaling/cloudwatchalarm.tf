resource "aws_cloudwatch_metric_alarm" "vpground-alarm1" {
  alarm_name          = "ec2-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 30
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.this-autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.this.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "vpground-alarm1-scaledown" {
  alarm_name          = "ec2-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.this-autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.this-scaledown.arn}"]
}