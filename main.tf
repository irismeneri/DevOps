module "network" {
  source = "./modules/network"
  app_name = var.app_name
  
}


module "eks_cluster" {
  source = "./modules/eks_cluster"
  app_name = var.app_name
  public_subnet_ids = module.network.public_subnet_ids
}


module "rds_instance" {
  source = "./modules/rds_instance"
  db_name = "grupi4db"
  instance_class = "db.t3.micro"
  username = "grupi4user"
  password = "grupi4password"
  db_subnet_group_name = module.network.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  depends_on = [module.eks_cluster]
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket_name = var.bucket_name
}



resource "aws_s3_bucket" "myweb-app-static-website" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}


resource "aws_eks_node_group" "eks-node-group" {
  cluster_name = module.eks_cluster.eks_cluster_name
  node_role_arn = module.eks_cluster.worker-nodes.arn
  subnet_ids = module.network.public_subnet_ids
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = module.eks_cluster.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = module.eks_cluster.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = module.eks_cluster.eks_cluster_role.name
}

resource "aws_db_parameter_group" "aws_db_parameter_group" {
  name = "grupi4-db-parameter-group"
  family = "postgres13"
  depends_on = [module.eks_cluster]
}

resource "aws_security_group" "db_security_group" {
  name = "grupi4-pg-sg"
  description = "Postgres security group"
  vpc_id = module.network.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [module.eks_cluster]
}


resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = module.s3_bucket.bucket_name
  

  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::myweb-app-static-website/*",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
POLICY
}

output "db-instance-endpoint" {
  value = module.rds_instance
}

data "aws_region" "current" {}

