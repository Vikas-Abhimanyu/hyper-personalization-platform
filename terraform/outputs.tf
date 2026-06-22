# --- VPC ---

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

# --- EKS ---

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

# --- Jenkins ---

output "jenkins_master_public_ip" {
  description = "Jenkins master public IP"
  value       = module.compute.jenkins_master_public_ip
}

# --- PostgreSQL ---

output "database_endpoint" {
  description = "PostgreSQL endpoint"
  value       = module.rds.db_instance_address
}

# --- Redis ---

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = module.elasticache.primary_endpoint_address
}

# --- Route53 ---

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.route53.hosted_zone_id
}

output "name_servers" {
  description = "Route53 nameservers"
  value       = module.route53.name_servers
}

# --- ACM ---

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.certificate.certificate_arn
}

# --- Secrets Manager ---

output "postgres_secret_arn" {
  description = "PostgreSQL secret ARN"
  value       = module.secrets.postgres_secret_arn
}

output "redis_secret_arn" {
  description = "Redis secret ARN"
  value       = module.secrets.redis_secret_arn
}

# --- Monitoring ---

output "alerts_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = module.monitoring.alerts_topic_arn
}