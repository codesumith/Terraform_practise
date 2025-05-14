provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "name" {
  ami = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  tags = {
    Name="lcl-rem"
  }

  provisioner "local-exec" {
    command = "echo Instance public ip is  :${self.public_ip} > ip_details.txt "
  }
}



