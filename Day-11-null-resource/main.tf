provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "s3_access_policy" {
  name = "Ec2S3acessPolicy"
  description = "Policy for ec2 instance to access s3"
  policy = jsonencode({ 
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ]
            Effect = "Allow"
            Resource = [
                "arn:aws:s3:::nknknkn",
                "arn:aws:s3:::nknknkn/*"
            ]
        }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
    name = "ec2_s3_access_role"
    assume_role_policy = jsonencode({
        Version ="2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                        Service = "ec2.amazonaws.com"
                } 
            }
        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_S3access_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "web_server" {
  ami = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  key_name = "ec2key-pair"
  security_groups = ["default"]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  availability_zone = "us-east-1a"

  tags = {
    Name = "MyWebServer"
  } 
}

resource "null_resource" "name" {

    depends_on = [ aws_instance.web_server ]

    provisioner "remote-exec" {
      
        inline = [ 
            # Install Apache if not installed
      "sudo yum install -y httpd",
      
      # Start Apache
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",

      # Ensure /var/www/html/ directory exists
      "sudo mkdir -p /var/www/html/",

      # Create a sample index.html file
      "echo '<h1>Welcome to My Web Server Sumith</h1>' | sudo tee /var/www/html/index.html",

      # Upload the file to S3
      "aws s3 cp /var/www/html/index.html s3://nknknkn/",
      "echo 'File uploaded to S3'"
         ]

    }

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("/Users/sumith/Desktop/awskey-pairs/ec2key-pair.pem")
      host = aws_instance.web_server.public_ip

    }

    triggers = {
        instance_id = aws_instance.web_server.id
    }
  
}