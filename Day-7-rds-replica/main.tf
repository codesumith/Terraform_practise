
resource "aws_db_subnet_group" "primary_subnet_group" {
    name = "myprimarysubnet"
    subnet_ids = ["subnet-0c493eeb80e2479cf","subnet-0d8f19388c932a951"]
    provider = aws.primary

    tags = {
      Name = "My Primary db subnet group"
    }
  
}

resource "aws_iam_role" "role_rds_monitoring" {
  name = "rds-monitoring-role-terraform"
  provider = aws.primary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
    provider = aws.primary
    role = aws_iam_role.role_rds_monitoring.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  
}


resource "aws_db_instance" "primary" {

    allocated_storage = 10
    identifier = "books-rds"
    db_name = "mydb"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t4g.micro"
    username = "admin"
    password = "Cloud123"
    db_subnet_group_name = aws_db_subnet_group.primary_subnet_group.id
    parameter_group_name = "default.mysql8.0"
    provider = aws.primary
    publicly_accessible = true

     # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.role_rds_monitoring.arn

  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = false

  # Skip final snapshot
  skip_final_snapshot = true
  
}




