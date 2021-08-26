resource "aws_autoscaling_group" "Vpground-asg" {
  max_size = 3
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  vpc_zone_identifier = ["${module.main-public-1.subnet_id}", "${module.main-public-2.subnet_id}"]
  launch_template {
    id = "${aws_launch_template.simple-ec2.id}"
    version = "$Latest"
  }
  force_delete = true
}

resource "aws_autoscaling_attachment" "VPG-asg-attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.Vpground-asg.id}"
  alb_target_group_arn = "${aws_alb_target_group.this-targetgroup.arn}"
}

resource "aws_autoscaling_policy" "this" {
  autoscaling_group_name = "${aws_autoscaling_group.Vpground-asg.name}"
  name                   = "vpground-autoscaling-policy"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "this-scaledown" {
  autoscaling_group_name = "${aws_autoscaling_group.Vpground-asg.name}"
  name                   = "vpground-autoscaling-policy-scaledown"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

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
    "AutoScalingGroupName" = "${aws_autoscaling_group.Vpground-asg.name}"
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
    "AutoScalingGroupName" = "${aws_autoscaling_group.Vpground-asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.this-scaledown.arn}"]
}