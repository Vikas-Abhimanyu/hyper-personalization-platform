variable "enable_waf" {
  description = "Enable AWS WAF"
  type        = bool
  default     = false
}

variable "alb_arn" {
  description = "Application Load Balancer ARN"
  type        = string
}

variable "rate_limit" {
  description = "Maximum requests per 5 minutes per IP"
  type        = number
  default     = 2000
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}