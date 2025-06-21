variable "security_ou_name" {
  description = "Name of the Security organizational unit"
  type        = string
  default     = "Security"
}


variable "security_account_name" {
  description = "Name of the security account"
  type        = string
  default     = "Security Account"
}

variable "security_account_email" {
  description = "Email address for the security account"
  type        = string
}

variable "logging_account_name" {
  description = "Name of the logging account"
  type        = string
  default     = "Logging Account"

}

variable "logging_account_email" {
  description = "Email address for the logging account"
  type        = string
}

variable "production_account_name" {
  description = "Name of the production account"
  type        = string
  default     = "Production Account"

}

variable "production_account_email" {
  description = "Email address for the Production account"
  type        = string
}

variable "product_ou_name" {
  description = "Name of the product organizational unit"
  type        = string
  default     = "Product"
}

variable "governed_regions" {
  description = "List of regions to be governed by the landing zone"
  type        = list(string)
  default     = ["eu-west-1", "eu-west-2", "eu-west-3"]
}
