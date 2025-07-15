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

############################################################################
# UnComment out this provider block if you are using a production profile
# and want to validate the Control Tower Landing Zone Controls
############################################################################

# provider "aws" {
#   alias   = "production"
#   profile = "production"
#   region  = "eu-west-1"
# }

############################################################################
# UnComment out this provider block if you are using a security profile
# and want to Delegate the Security Account as the Organization Delegated Admin
############################################################################

provider "aws" {
  region  = "eu-west-1"
  alias   = "security"
  profile = "security"
}

############################################################################
# UnComment out this provider block if you are using a logging and product profile
# and want to Enable DATAODG INTEGRAION FOR CONTROL TOWER
############################################################################
# provider "aws" {
#   region  = "eu-west-1"
#   alias   = "logging"
#   profile = "logging"
# }

############################################################################
# UnComment out this provider block if you are using a logging and product profile
# and want to Enable invite acceptors for Security Hub
############################################################################
# provider "aws" {
#   region  = "eu-west-1"
#   alias   = "logging"
#   profile = "logging"
# }

# provider "aws" {
#   region  = "eu-west-1"
#   alias   = "production"
#   profile = "production"
# }
