output "alerts_topic_arn" {
  description = "SNS topic ARN used for infrastructure alerts"
  value       = aws_sns_topic.alerts.arn
}

output "alerts_topic_name" {
  description = "SNS topic name"
  value       = aws_sns_topic.alerts.name
}