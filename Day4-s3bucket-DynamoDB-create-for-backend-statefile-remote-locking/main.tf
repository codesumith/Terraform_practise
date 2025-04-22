resource "aws_s3_bucket" "name" {
  bucket = "bucket-for-storing-statefile"
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name = "terrafomr-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
  
}