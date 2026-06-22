# --- SNS Topic for Alerts ---

resource "aws_sns_topic" "alerts" {

  name = "${var.name_prefix}-alerts"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alerts"
    }
  )
}

# --- Email Subscription ---

resource "aws_sns_topic_subscription" "email" {

  count = var.alert_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# --- CPU Alarm for Jenkins Master ---

resource "aws_cloudwatch_metric_alarm" "jenkins_cpu" {

  alarm_name          = "${var.name_prefix}-jenkins-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold

  dimensions = {
    InstanceId = var.jenkins_master_instance_id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# --- EKS Node CPU Alarm ---

resource "aws_cloudwatch_metric_alarm" "eks_cpu" {

  alarm_name          = "${var.name_prefix}-eks-node-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = var.eks_cpu_alarm_threshold

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}