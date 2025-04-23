# vpc
resource "aws_vpc" "custom_vpc"{
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "custom_vpc"
    }
}

 # igw and attach to vpc
resource "aws_internet_gateway" "custom_igw" {
    vpc_id = aws_vpc.custom_vpc.id

    tags = {
      Name = "custom_igw"
    }
}

# public  subnet 1
resource "aws_subnet" "public_subnet_1a" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "public_subnet-1a"
    }
}

# private subnet 2 
resource "aws_subnet" "private_subnet_1b" {
      vpc_id = aws_vpc.custom_vpc.id
      cidr_block = "10.0.1.0/24"
      availability_zone = "us-east-1b"

    tags = {
      Name = "private_subnet-1b"
    }
}

# elasticip for nat 
resource "aws_eip" "eip_for_natgw" {
    
}

# natgw
resource "aws_nat_gateway" "ntgw" {
    allocation_id = aws_eip.eip_for_natgw.id
    subnet_id = aws_subnet.public_subnet_1a.id

    tags = {
      Name = "nat-gateway"
    }

    depends_on = [ aws_internet_gateway.custom_igw ]
}

# rt for public subnet and edit routes igw to rt
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_igw.id
    }

    tags = {
      Name = "public_rt"
    }

}
# public subnet association to rt
resource "aws_route_table_association" "pub_sub_association" {
    subnet_id = aws_subnet.public_subnet_1a.id
    route_table_id = aws_route_table.public_rt.id
}

# rt for private subnet and edit routes nat to rt
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ntgw.id
  }

  tags = {
    Name = "private-rt"
  }

}
# private subnet association to rt
resource "aws_route_table_association" "private_sub_association" {
  subnet_id = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_rt.id
}

# sg
resource "aws_security_group" "web_sg" {
    name = "web-sg"
    description = "Allow HTTP and ssh traffic"
    vpc_id = aws_vpc.custom_vpc.id

    ingress {
        description = "Allow http traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
        description = "Allow ssh traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
            description = "Allow all outbount traffic"
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
    }
  
 tags = {
   Name = "web-security-group"
 }

}


# public server 
resource "aws_instance" "pub_server" {
    ami = "ami-00a929b66ed6e0de6"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_1a.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name = "    "

    tags = {
      Name = "public-server"
    }
  
}
# private server
resource "aws_instance" "pvt_server"{
        ami = "ami-00a929b66ed6e0de6"
        instance_type = "t2.micro"
        subnet_id = aws_subnet.private_subnet_1b.id
        associate_public_ip_address = false
        vpc_security_group_ids = [aws_security_group.web_sg.id]
        key_name = "ec2key-pair"

        tags = {
      Name = "private-server"
    }

}





# vpc
# igw and attach to vpc
# public  subnet 1
# private subnet 2 
# natgw
# rt for public subnet and edit routes igw to rt
# public subnet association to rt
# rt for private subnet and edit routes nat to rt
# private subnet association to rt
# sg
# public server 
# private server