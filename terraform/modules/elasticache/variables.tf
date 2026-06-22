variable "private_subnet_ids" {
  description = "Private subnet IDs used by Redis"
  type        = list(string)
}

variable "redis_security_group_id" {
  description = "Security group ID for Redis"
  type        = string
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
}

variable "node_type" {
  description = "Redis node type"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of Redis cache nodes"
  type        = number

  validation {
    condition     = var.num_cache_nodes > 0
    error_message = "num_cache_nodes must be greater than 0."
  }
}

variable "automatic_failover_enabled" {
  description = "Enable Redis automatic failover"
  type        = bool
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ for Redis"
  type        = bool
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "snapshot_retention_limit" {
  type = number
}