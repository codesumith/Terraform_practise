# resource "aws_vpc" "replica_vpc" {
#     cidr_block = "10.0.0.0/16"
#     provider = aws.replica
#     enable_dns_support   = true
#   enable_dns_hostnames = true

#     tags = {
#       Name="replica_vpc"
#     }
  
# }

# resource "aws_internet_gateway" "replica_igw" {
#     provider = aws.replica
#     vpc_id = aws_vpc.replica_vpc.id
  
# }

# resource "aws_subnet" "rep-sub-1a" {
#   cidr_block = "10.0.0.0/24"
#   vpc_id = aws_vpc.replica_vpc.id
#   availability_zone = "us-west-2a"
#   provider = aws.replica
# }

# resource "aws_subnet" "rep-sub-1b" {
#   cidr_block = "10.0.1.0/24"
#   vpc_id = aws_vpc.replica_vpc.id
#   availability_zone = "us-west-2b"
#   provider = aws.replica
# }

# resource "aws_route_table" "rep_rt" {
#     vpc_id = aws_vpc.replica_vpc.id
#     provider = aws.replica
#     route{
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.replica_igw.id
#     }
  
# }

# resource "aws_route_table_association" "one_a" {
#     subnet_id = aws_subnet.rep-sub-1a.id
#     route_table_id = aws_route_table.rep_rt.id
#     provider = aws.replica
  
# }

# resource "aws_route_table_association" "one_b" {
#     subnet_id = aws_subnet.rep-sub-1b.id
#     route_table_id = aws_route_table.rep_rt.id
#     provider = aws.replica
  
# }

# resource "aws_db_subnet_group" "replica_sb_gp" {
#   name = "replica-subnet-group"
#   provider = aws.replica
#   subnet_ids = [aws_subnet.rep-sub-1a.id, aws_subnet.rep-sub-1b.id]
#   tags = {
#     Name = "Replica Region Subnet Group"
#   }
# }

# resource "aws_db_instance" "replica_db" {
#   identifier = "book-rds-replica"
#   replicate_source_db = aws_db_instance.primary.arn
#   instance_class = "db.t4g.micro"
#   provider = aws.replica

#   # Network configuration in secondary region
#   db_subnet_group_name = aws_db_subnet_group.replica_sb_gp.name
#   publicly_accessible = true

#   skip_final_snapshot = true


#   depends_on = [ aws_db_instance.primary ]


# }

