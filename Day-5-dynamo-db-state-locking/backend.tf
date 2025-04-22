terraform {
  backend "s3" {
    bucket = "bucket-for-storing-statefile"
    region = "us-east-1"
    key = "terraform.tfstate"
    dynamodb_table = "terrafomr-state-lock-dynamo"
    encrypt = true
  }
}