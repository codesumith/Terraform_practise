resource "aws_instance" "ec2" {
  instance_type = var.instance_type
  ami = var.ami
  
  tags = {
    Name = var.name
  }

}