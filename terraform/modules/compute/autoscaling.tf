# --- Jenkins Worker Auto Scaling Group ---

resource "aws_autoscaling_group" "jenkins_workers" {

  name = "${var.name_prefix}-jenkins-workers"

  min_size         = 1
  desired_capacity = 1
  max_size         = 3

  vpc_zone_identifier = var.private_subnet_ids

  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {

    id      = aws_launch_template.jenkins_worker.id
    version = "$Latest"
  }

  tag {

    key                 = "Name"
    value               = "${var.name_prefix}-jenkins-worker"
    propagate_at_launch = true
  }

  tag {

    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}