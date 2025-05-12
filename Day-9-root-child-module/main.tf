
# module "test" {
#   source = "./modules/ec2"
#   ami = "ami-00a929b66ed6e0de6"
#   instance_type = "t2.micro"
# }

module "s3" {
  source = "./modules/s3"
  bucket_name = "sumitttthh"
  environment = "dev"
  versioning = "true"
}

