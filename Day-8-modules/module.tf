module "dev" {
  source = "../Day-8-modules-source"
  ami_id = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  insance_name = "ec2-micro"
}