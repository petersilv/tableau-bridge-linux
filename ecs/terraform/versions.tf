terraform {
  required_version = ">= 1.3.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
