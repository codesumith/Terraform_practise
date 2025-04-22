
terraform {
    backend "s3"{
        bucket = "bucket-for-storing-statefile"
        key = "Day-4/terraform.tfstate"
        region = "us-east-1"
    }
}
