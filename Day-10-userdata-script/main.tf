resource "aws_instance" "dev" {
    tags = {
      Name = "deusd"
    }
    ami = "ami-00a929b66ed6e0de6"
    instance_type = "t2.micro"
    user_data = file("script.sh")
    vpc_security_group_ids  = [ "sg-018699b21dd785818" ]
  
}