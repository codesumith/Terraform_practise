provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "server" {
  ami = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  key_name = "ec2key-pair"

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/Users/sumith/Desktop/awskey-pairs/ec2key-pair.pem")
    host = self.public_ip
  }

  provisioner "local-exec" {
    command = "touch file500"
  }

  provisioner "file" {
    source = "file10"
    destination = "/home/ec2-user/file10"
  }

  provisioner "remote-exec" {
    inline = [ 
        "touch file200",
        "echo hello from aws >> file200"
     ]
  }
}

