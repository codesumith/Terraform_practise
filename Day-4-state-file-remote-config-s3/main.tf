resource "aws_vpc" "dev_vpc"{
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "dev_sb_1a" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "test_sb_1b" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
}

resource "aws_subnet" "uat_sb_1d" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1d"
}