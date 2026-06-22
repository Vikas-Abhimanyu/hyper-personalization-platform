resource "aws_kms_key" "eks" {

  description             = "KMS key for EKS secret encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-eks-kms-key"
    }
  )
}

resource "aws_kms_alias" "eks" {

  name          = "alias/${var.name_prefix}-eks"
  target_key_id = aws_kms_key.eks.key_id
}