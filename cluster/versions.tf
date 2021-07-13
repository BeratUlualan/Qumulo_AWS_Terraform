terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      version = ">= 3.40"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
