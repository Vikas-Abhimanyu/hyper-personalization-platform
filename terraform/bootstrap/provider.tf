provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "hyper-personalization-platform"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}   