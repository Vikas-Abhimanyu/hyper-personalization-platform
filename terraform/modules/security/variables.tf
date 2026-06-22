variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}

variable "allowed_admin_cidr" {
  description = "CIDR block allowed to access Jenkins and SSH"

  type = string

  validation {
    condition     = can(cidrhost(var.allowed_admin_cidr, 0))
    error_message = "allowed_admin_cidr must be a valid CIDR block."
  }
}