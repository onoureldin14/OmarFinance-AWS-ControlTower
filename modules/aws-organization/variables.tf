variable "organization_accounts" {
  description = "Map of accounts to create with their email addresses and names"
  type = map(object({
    name  = string
    email = string
    ou    = optional(string)
  }))
  default = {
    security = {
      name  = "Security Account"
      email = "security@example.com"
    }
    logging = {
      name  = "Logging Account"
      email = "logging@example.com"
    }
  }
}
variable "organizational_units" {
  description = "List of OUs to create under the root"
  type = map(object({
    name      = string
    parent_id = optional(string) # Optional parent ID for nested OUs
  }))
  default = {}
}

variable "delegated_security_services" {
  description = "values for security foundation principles"
  type        = list(string)
  default = [
    "access-analyzer.amazonaws.com",
    "iam.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
  ]
}

variable "enable_security_account_delegated_admin" {
  description = "Flag to enable delegated administration for the security account"
  type        = bool
  default     = false
}

variable "aws_security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
  default     = "" # replace with actual security account ID
}
