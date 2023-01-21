provider "aws"{
    access_key = var.AWS_ACCKEY
    secret_key = var.AWS_SECRKEY
    region = var.AWS_REGION
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }
  }
}