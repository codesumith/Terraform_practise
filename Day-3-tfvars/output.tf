output "ip" {
  value = aws_instance.name.public_ip
}

output "instance_az"{
    value = aws_instance.name.availability_zone
}