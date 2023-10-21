variable "app_name" {
  type = string
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["subnet-12345678", "subnet-87654321"]
}



