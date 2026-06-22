environment = "prod"

aws_region = "ap-south-1"

vpc_cidr = "10.2.0.0/16"

public_subnet_cidrs = [
  "10.2.1.0/24",
  "10.2.2.0/24"
]

private_subnet_cidrs = [
  "10.2.11.0/24",
  "10.2.12.0/24"
]

azs = [
  "ap-south-1a",
  "ap-south-1b"
]

single_nat_gateway = false

domain_name = "example.com"

subject_alternative_names = [
  "*.example.com"
]


cluster_version = "1.33"
capacity_type   = "ON_DEMAND"

node_group_instance_types = [
  "m7g.large"
]

desired_size = 3
min_size     = 3
max_size     = 8

database_name     = "hyperpersonalization"
database_username = "postgres"

rds_engine_version        = "17.2"
rds_instance_class        = "db.r7g.large"
rds_allocated_storage     = 100
rds_max_allocated_storage = 500

multi_az                = true
backup_retention_period = 30
deletion_protection     = true

redis_engine_version    = "8.0"
redis_node_type         = "cache.r7g.large"
num_cache_nodes         = 2
redis_multi_az_enabled  = true
redis_failover_enabled  = true
snapshot_retention_limit = 30

alert_email = "alerts@example.com"

enable_waf     = true
waf_rate_limit = 2000

# --- MSK ---

cluster_name           = "hyperpersonalization-msk-prod"
number_of_broker_nodes = 3
instance_type          = "kafka.m7g.large"
volume_size            = 1000
private_subnet_ids     = ["subnet-abc123", "subnet-def456"]
security_group_id      = "sg-123456"
kms_key_arn            = "arn:aws:kms:ap-south-1:111111111111:key/abcd-efgh"
cloudwatch_log_group   = "/aws/msk/hyperpersonalization-prod"

common_tags = {
  Environment = "prod"
  Project     = "HyperPersonalization"
}
