environment = "staging"

aws_region = "ap-south-1"

vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnet_cidrs = [
  "10.1.11.0/24",
  "10.1.12.0/24"
]

azs = [
  "ap-south-1a",
  "ap-south-1b"
]

single_nat_gateway = true

domain_name = "staging.example.com"

subject_alternative_names = [
  "*.staging.example.com"
]


cluster_version = "1.33"
capacity_type   = "ON_DEMAND"

node_group_instance_types = [
  "t3.large"
]

desired_size = 2
min_size     = 2
max_size     = 4

database_name     = "hyperpersonalization"
database_username = "postgres"

rds_engine_version        = "17.2"
rds_instance_class        = "db.t4g.small"
rds_allocated_storage     = 50
rds_max_allocated_storage = 200

multi_az                = false
backup_retention_period = 3
deletion_protection     = false

redis_engine_version    = "8.0"
redis_node_type         = "cache.t4g.small"
num_cache_nodes         = 1
redis_multi_az_enabled  = false
redis_failover_enabled  = false
snapshot_retention_limit = 7

alert_email = ""

enable_waf     = false
waf_rate_limit = 2000

# --- MSK ---

cluster_name           = "hyperpersonalization-msk-staging"
number_of_broker_nodes = 3
instance_type          = "kafka.m7g.large"
volume_size            = 1000
private_subnet_ids     = ["subnet-abc123", "subnet-def456"]
security_group_id      = "sg-123456"
kms_key_arn            = "arn:aws:kms:ap-south-1:111111111111:key/abcd-efgh"
cloudwatch_log_group   = "/aws/msk/hyperpersonalization-staging"

common_tags = {
  Environment = "staging"
  Project     = "HyperPersonalization"
}
