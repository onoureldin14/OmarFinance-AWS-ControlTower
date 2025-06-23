terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
  required_version = ">= 0.13"
}


provider "aws" {
  region = "eu-west-1"
}

# Comment out this provider block if you are not using a production profile
# and dont need to validate the Control Tower Landing Zone Controls
provider "aws" {
  alias   = "production"
  profile = "production"
  region  = "eu-west-1"
}
