resource "aws_instance" "name" {
    ami = "ami-00a929b66ed6e0de6"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"



    lifecycle {
      # If you change something like the availability zone, 
      # subnet, or attached volumes, Terraform might have to 
      # destroy the original instance before creating the new 
      # one — especially if the AMI or instance configuration requires it.
       create_before_destroy = true 
       ignore_changes = [ tags ]
      #  prevent_destroy = true

    }

   
}
