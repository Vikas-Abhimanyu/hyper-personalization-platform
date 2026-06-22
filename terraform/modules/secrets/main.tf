# --- PostgreSQL Password ---

resource "aws_secretsmanager_secret" "postgres" {

  name                    = "${var.name_prefix}/postgres"
  recovery_window_in_days = 7

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-postgres-secret"
    }
  )
}

resource "aws_secretsmanager_secret_version" "postgres" {

  secret_id = aws_secretsmanager_secret.postgres.id

  secret_string = jsonencode({
    username = var.database_username
    password = var.database_password
    host     = var.database_host
    port     = var.database_port
    database = var.database_name
  })
}

# --- Redis Secret ---

resource "aws_secretsmanager_secret" "redis" {

  name                    = "${var.name_prefix}/redis"
  recovery_window_in_days = 7

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-redis-secret"
    }
  )
}

resource "aws_secretsmanager_secret_version" "redis" {

  secret_id = aws_secretsmanager_secret.redis.id

  secret_string = jsonencode({
    host = var.redis_host
    port = var.redis_port
  })
}