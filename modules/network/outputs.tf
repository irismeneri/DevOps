output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db-subnet-group.name
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

