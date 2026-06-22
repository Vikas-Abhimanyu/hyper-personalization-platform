variable "database_username" {
  description = "Database master username"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "database_host" {
  description = "RDS endpoint"
  type        = string
}

variable "database_port" {
  description = "RDS port"
  type        = number
}

variable "redis_host" {
  description = "Redis endpoint"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "database_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}