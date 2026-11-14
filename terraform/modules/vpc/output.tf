output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "webapp_sg_id" {
  value = aws_security_group.webApp_vpc_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_vpc_sg.id
}

