resource "aws_dynamodb_table" "terraform_lock" {

  name         = "${var.name_prefix}-tf-locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.name_prefix}-tf-locks"
  }
}