variable "governed_regions" {
  description = "List of regions to be governed by the landing zone"
  type        = list(string)
}

variable "security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
}

variable "logging_account_id" {
  description = "AWS Account ID for the logging account"
  type        = string
}

variable "backup_account_id" {
  description = "AWS Account ID for the backup admin account"
  type        = string
  default     = ""
}

variable "central_backup_account_id" {
  description = "AWS Account ID for the central backup account"
  type        = string
  default     = ""
}


variable "aws_control_tower_landing_zone_version" {
  description = "The version of the AWS Control Tower Landing Zone to deploy"
  type        = string
  default     = "3.3"
}

variable "security_org_name" {
  description = "Name of the security organization"
  type        = string
}


variable "logging_retention_days" {
  description = "Retention days for the logging bucket"
  type        = number
  default     = 60
}

variable "access_logging_retention_days" {
  description = "Retention days for the access logging bucket"
  type        = number
  default     = 60
}

variable "access_management_enabled" {
  description = "Flag to enable or disable access management"
  type        = bool
  default     = true
}

variable "centralised_logging_enabled" {
  description = "Flag to enable or disable centralized logging"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Flag to enable or disable backup"
  type        = bool
  default     = false
}

variable "enable_controls" {
  description = "Enable Control Tower controls"
  type        = bool
  default     = false
}

variable "ou_arns" {
  type        = map(string)
  description = "Map of OU ARNs keyed by name"
  default     = {}
}

variable "controls" {
  description = "Map of controls to apply"
  type = map(object({
    alias              = string
    control_identifier = string
    target_ou_key      = string # Key to lookup in OU ARNs map
  }))
  default = {}
}
