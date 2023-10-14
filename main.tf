module "network" {
  source = "./modules/network"
  app_name = var.app_name
  
}

module "eks_cluster" {
  source = "./modules/eks_cluster"
  app_name = var.app_name
  public_subnet_ids = module.network.public_subnet_ids
}


resource "aws_db_parameter_group" "aws_db_parameter_group" {
  name = "iris-db-parameter-group"
  family = "postgres16"

  depends_on = [module.eks_cluster]
}

resource "aws_security_group" "db_security_group" {
  name = "iris-pg-sg"
  description = "Postfres  security group"
  vpc_id = module.network.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }
  
  depends_on = [module.eks_cluster]
}

resource "aws_db_instance" "rds" {
    allocated_storage    = 20
    db_name              = "iris-db" 
    engine               = "postgres"
    engine_version       = "16.0"
    identifier           = "iris-db-instance" 
    instance_class       = "db.t3.micro"
    username             = "irisuser"
    password             = "irispassword"
    parameter_group_name =  aws_db_parameter_group.aws_db_parameter_group.name
    db_subnet_group_name = module.network.db_subnet_group_name
    vpc_security_group_ids = [aws_security_group.db_security_group.id]

    depends_on = [module.eks_cluster]
  
}

