output "public_ip" {

  value = aws_instance.App.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_id" {
  value = aws_security_group.SG.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_1.id
}

