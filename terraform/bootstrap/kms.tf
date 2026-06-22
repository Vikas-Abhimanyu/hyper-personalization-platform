resource "aws_kms_key" "terraform_state" {

  description             = "Terraform state encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.name_prefix}-terraform-state-kms"
  }
}

resource "aws_kms_alias" "terraform_state" {

  name          = "alias/${var.name_prefix}-terraform-state"
  target_key_id = aws_kms_key.terraform_state.key_id
}