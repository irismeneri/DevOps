variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "The Cidr Block for the VPC"
  
}

variable "public_subnets" {
    type = map
    default = {
        "a"="10.0.0.0/24"
        "b"="10.0.1.0/24"
    }
  
}

variable "private_subnets" {
    type = map
    default = {
        
    }

  
}

variable "app_name" {
    type = string
  
}