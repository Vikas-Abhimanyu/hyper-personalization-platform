resource "random_password" "postgres" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()-_=+"
}

# --- DB Subnet Group ---

resource "aws_db_subnet_group" "this" {

  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-db-subnet-group"
    }
  )
}

# --- PostgreSQL RDS ---

resource "aws_db_instance" "this" {

  identifier = "${var.name_prefix}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  storage_type = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = var.database_username
  password = random_password.postgres.result

  port = 5432

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection

  publicly_accessible = false

  skip_final_snapshot = false

  final_snapshot_identifier = "${var.name_prefix}-postgres-final"

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    var.database_security_group_id
  ]

  auto_minor_version_upgrade = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-postgres"
    }
  )
}

