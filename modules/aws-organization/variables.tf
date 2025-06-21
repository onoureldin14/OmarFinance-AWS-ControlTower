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
