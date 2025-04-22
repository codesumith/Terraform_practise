resource "aws_instance" "ec2-example"{
 ami = "ami-00a929b66ed6e0de6"
 instance_type = "t2.micro"
 tags = {
   Name = "example"
 }
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"
     depends_on = [ aws_instance.ec2-example ]
}