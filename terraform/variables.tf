# --- Environment ---

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

# --- Networking ---

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

# --- Compute ---

variable "ami_id" {
  type    = string
  default = ""
}

variable "master_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "worker_instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type    = string
  default = ""
}

# --- Domain ---

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

# --- EKS ---

variable "cluster_version" {
  type = string
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "node_group_instance_types" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

# --- PostgreSQL ---

variable "database_name" {
  type = string
}

variable "database_username" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_allocated_storage" {
  type = number
}

variable "rds_max_allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

# --- Redis ---

variable "redis_engine_version" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "num_cache_nodes" {
  type = number
}

variable "redis_multi_az_enabled" {
  type = bool
}

variable "redis_failover_enabled" {
  type = bool
}

variable "snapshot_retention_limit" {
  description = "Redis snapshot retention days"
  type        = number
}

# --- Monitoring ---

variable "alert_email" {
  type    = string
  default = ""
}

# --- WAF ---

variable "enable_waf" {
  type = bool
}

variable "waf_rate_limit" {
  type    = number
  default = 2000
}