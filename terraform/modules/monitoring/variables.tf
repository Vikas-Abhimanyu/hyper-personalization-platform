variable "alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
  default     = ""
}

variable "jenkins_master_instance_id" {
  description = "Jenkins master EC2 instance ID"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cpu_alarm_threshold" {
  description = "CPU threshold for Jenkins EC2 alarm"
  type        = number
  default     = 80
}

variable "eks_cpu_alarm_threshold" {
  description = "CPU threshold for EKS nodes"
  type        = number
  default     = 80
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}