# --- Route53 ---

module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name

  create_root_record = false

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Network ---

module "network" {
  source = "./modules/network"

  cluster_name = local.cluster_name

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  azs = var.azs

  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.azs)

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}


# --- Security Groups ---

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id

  allowed_admin_cidr = "0.0.0.0/0"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- ECR ---

module "ecr" {

  source = "./modules/ecr"

  repository_names = [
    "claims-service",
    "customer-service",
    "policy-service",
    "notification-service",
    "frontend"
  ]

  common_tags = local.common_tags
}

# --- backup/velero ---

module "backup" {
  source = "./modules/backup"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  velero_irsa_role_arn = module.iam.velero_irsa_role_arn
}

# --- IAM ---

module "iam" {
  source = "./modules/iam"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- KMS ---

module "kms" {
  source = "./modules/kms"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- EKS ---

module "eks" {
  source = "./modules/eks"

  cluster_name = local.cluster_name

  private_subnet_ids = module.network.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  cluster_sg_id = module.security.eks_cluster_security_group_id
  kms_key_arn   = module.kms.eks_kms_key_arn

  cluster_version = var.cluster_version

  node_instance_type = var.node_group_instance_types[0]

  desired_node_count = var.desired_size
  min_node_count     = var.min_size
  max_node_count     = var.max_size

  capacity_type = var.capacity_type

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Jenkins Infrastructure ---

module "compute" {
  source = "./modules/compute"

  aws_region   = var.aws_region
  cluster_name = module.eks.cluster_name

  public_subnet_id   = module.network.public_subnet_ids[0]
  private_subnet_ids = module.network.private_subnet_ids

  jenkins_master_sg_id = module.security.jenkins_master_security_group_id
  jenkins_worker_sg_id = module.security.jenkins_worker_security_group_id

  ami_id = var.ami_id

  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type

  jenkins_master_instance_profile = module.iam.jenkins_master_instance_profile
  jenkins_worker_instance_profile = module.iam.jenkins_worker_instance_profile

  key_name = var.key_name

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- PostgreSQL ---

module "rds" {
  source = "./modules/rds"

  private_subnet_ids         = module.network.private_subnet_ids
  database_security_group_id = module.security.database_security_group_id

  database_name     = module.rds.database_name
  database_username = var.database_username
  database_password = module.rds.database_password

  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Redis ---

module "elasticache" {
  source = "./modules/elasticache"

  private_subnet_ids      = module.network.private_subnet_ids
  redis_security_group_id = module.security.redis_security_group_id

  redis_engine_version       = var.redis_engine_version
  node_type                  = var.redis_node_type
  num_cache_nodes            = var.num_cache_nodes
  automatic_failover_enabled = var.redis_failover_enabled
  multi_az_enabled           = var.redis_multi_az_enabled

  snapshot_retention_limit = var.snapshot_retention_limit

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Secrets Manager ---

module "secrets" {
  source = "./modules/secrets"

  database_host     = module.rds.endpoint
  database_port     = module.rds.port
  database_name     = var.database_name
  database_username = var.database_username
  database_password = module.rds.database_password

  redis_host = module.elasticache.primary_endpoint_address
  redis_port = module.elasticache.redis_port

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- ACM Certificate ---

module "certificate" {
  source = "./modules/certificate"

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  hosted_zone_id = module.route53.hosted_zone_id

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Monitoring ---

module "monitoring" {
  source = "./modules/monitoring"

  alert_email = var.alert_email

  jenkins_master_instance_id = module.compute.jenkins_master_instance_id
  cluster_name               = module.eks.cluster_name

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- Kubernetes ---

module "kubernetes" {
  source = "./modules/kubernetes"

  cluster_name   = module.eks.cluster_name
  aws_region     = var.aws_region
  domain_name    = var.domain_name
  hosted_zone_id = module.route53.hosted_zone_id

  velero_bucket_name = module.backup.velero_bucket_name

  alb_ingress_irsa_role_arn     = module.iam.alb_ingress_irsa_role_arn
  cluster_autoscaler_irsa_role_arn = module.iam.cluster_autoscaler_irsa_role_arn
  external_secrets_irsa_role_arn   = module.iam.external_secrets_irsa_role_arn
  velero_irsa_role_arn             = module.iam.velero_irsa_role_arn

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  depends_on = [ module.eks ]
}

# --- WAF ---

module "waf" {
  source = "./modules/waf"

  enable_waf = var.enable_waf

  # attach later when ALB exists
  alb_arn = ""

  rate_limit = var.waf_rate_limit

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

# --- MSK ---

module "msk" {
  source = "./modules/msk"

  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  instance_type          = var.instance_type
  volume_size            = var.volume_size

  private_subnet_ids   = var.private_subnet_ids
  security_group_id    = var.security_group_id
  kms_key_arn          = var.kms_key_arn
  cloudwatch_log_group = var.cloudwatch_log_group
  common_tags          = var.common_tags
}
