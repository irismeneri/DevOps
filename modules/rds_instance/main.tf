resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = var.db_name
  engine = "postgres"
  engine_version = "13"
  identifier = "grupi4-db-instance"
  instance_class = var.instance_class
  username = var.username
  password = var.password
  skip_final_snapshot = true
  parameter_group_name = aws_db_parameter_group.aws_db_parameter_group.name
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
}

resource "aws_db_parameter_group" "aws_db_parameter_group" {
  name = "grupi4-db-parameter-group"
  family = "postgres13"
}


