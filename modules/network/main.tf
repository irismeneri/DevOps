resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = "eu-north-1${each.key}"

  tags = {
    Name = "${var.app_name}-public-subnet-1${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = "eu-north-1${each.key}"

  tags = {
    Name = "${var.app_name}-private-subnet-1${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route-table-association" {
  for_each = aws_subnet.public_subnets

  route_table_id = aws_route_table.route-table.id
  subnet_id      = each.value.id
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.public_subnets : subnet.id]
}
