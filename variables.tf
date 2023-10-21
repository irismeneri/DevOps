variable "app_name" {
    type = string
    default = "grupi4"
  
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["subnet-12345678", "subnet-87654321"]
}

variable "bucket_name" {
  type = string
  default = "grupi-4"
  
}