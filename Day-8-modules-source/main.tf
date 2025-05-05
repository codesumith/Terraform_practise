resource "aws_instance" "ec-2" {
  ami = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.insance_name
  }
}