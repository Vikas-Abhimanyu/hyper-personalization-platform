# --- Redis Subnet Group ---

resource "aws_elasticache_subnet_group" "this" {

  name       = "${var.name_prefix}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# --- Redis Replication Group ---

resource "aws_elasticache_replication_group" "this" {

  replication_group_id = "${var.name_prefix}-redis"

  description = "Redis cluster for ${var.name_prefix}"

  engine               = "redis"
  engine_version       = var.redis_engine_version
  node_type            = var.node_type
  parameter_group_name = "default.redis8"

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.this.name

  security_group_ids = [
    var.redis_security_group_id
  ]

  num_cache_clusters = var.num_cache_nodes

  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  auto_minor_version_upgrade = true

  snapshot_retention_limit = var.snapshot_retention_limit

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-redis"
    }
  )
}