locals {

  # --- Naming ---

  project_name = "hyper-personalization"

  name_prefix = "${var.environment}-${local.project_name}"

  cluster_name = "${local.name_prefix}-eks"

  # --- Common Tags ---

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}