output "postgres_secret_arn" {
  description = "ARN of PostgreSQL secret"
  value       = aws_secretsmanager_secret.postgres.arn
}

output "postgres_secret_name" {
  description = "Name of PostgreSQL secret"
  value       = aws_secretsmanager_secret.postgres.name
}

output "redis_secret_arn" {
  description = "ARN of Redis secret"
  value       = aws_secretsmanager_secret.redis.arn
}

output "redis_secret_name" {
  description = "Name of Redis secret"
  value       = aws_secretsmanager_secret.redis.name
}