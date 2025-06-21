terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = "eu-west-1"
}
