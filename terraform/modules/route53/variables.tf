variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "create_root_record" {
  description = "Whether to create root alias record"
  type        = bool
  default     = false
}

variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
  default     = null
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}