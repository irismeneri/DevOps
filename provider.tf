terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
    access_key = "AKIAR4IDLG2MMIYRWYL6"
  secret_key = "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"
}
