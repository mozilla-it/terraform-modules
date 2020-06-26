resource "aws_s3_bucket" "terraform-backend-bucket" {
  bucket = var.backend_bucket
  region = var.region
  tags   = var.tags

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "aws_dynamodb_table" "terraform-backend-dynamodb" {
  # ref https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  hash_key = "LockID"
  name     = var.backend_dynamodb_table

  # Billing mode provisioned requires us to plan for write/read
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  # Required because we defined a hash_key
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}
