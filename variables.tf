variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "aws_secondary_region" {
  description = "Secondary AWS region for cross-region replication"
  type        = string
  default     = "eu-west-2"
}

variable "github_organization" {
  description = "GitHub organization name for the repository"
  type        = string
}

variable "company_name" {
  description = "Name of the company for branding purposes"
  type        = string
  default     = "OmarFinance"
}

variable "management_account_email" {
  description = "Email address for the management account"
  type        = string
  default     = "" # replace with actual management account email
}

variable "governed_regions" {
  description = "List of regions to be governed by the landing zone"
  type        = list(string)
  default     = ["eu-west-1", "eu-west-2", "eu-west-3"]
}

variable "securityhub_aggregator_specified_regions" {
  description = "List of regions to enable Security Hub finding aggregator"
  type        = list(string)
  default     = ["eu-west-2", "eu-west-3"]
}

variable "enable_controls" {
  description = "Enable Control Tower controls"
  type        = bool
  default     = true
}

# tflint-ignore: terraform_unused_declarations
variable "validate_controls" {
  description = "Flag to validate controls"
  type        = bool
  default     = false
}

# tflint-ignore: terraform_unused_declarations
variable "enable_invite_acceptors" {
  description = "Flag to enable invite acceptors for Security Hub"
  type        = bool
  default     = false
}

variable "slack_channel_id" {
  description = "Slack channel ID for the chatbot integration"
  type        = string
  default     = "" # replace with actual Slack channel ID
}

variable "slack_team_id" {
  description = "Slack team ID for the chatbot integration"
  type        = string
  default     = "" # replace with actual Slack team ID
}


##################################################
# Security Account Variables
##################################################

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

variable "security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
  default     = "" # replace with actual security account ID
}

##################################################
# Logging Account Variables
##################################################

variable "logging_account_email" {
  description = "Email address for the logging account"
  type        = string
}

variable "logging_account_name" {
  description = "Name of the logging account"
  type        = string
  default     = "Logging Account"
}

variable "logging_account_id" {
  description = "AWS Account ID for the logging account"
  type        = string
  default     = "" # replace with actual logging account ID
}

##################################################
# Product OU and Production Account Variables
##################################################


variable "product_ou_name" {
  description = "Name of the product organizational unit"
  type        = string
  default     = "Product"
}

variable "production_account_id" {
  description = "AWS Account ID for the production account"
  type        = string
  default     = "" # replace with actual production account ID
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

##################################################
# Platform OU and AFT  Account Variables
##################################################

variable "platform_ou_name" {
  description = "Name of the platform organizational unit"
  type        = string
  default     = "Platform"
}

variable "aft_account_name" {
  description = "Name of the AFT account"
  type        = string
  default     = "AFT Account"
}

variable "aft_account_email" {
  description = "Email address for the AFT account"
  type        = string
}

variable "aft_account_id" {
  description = "AWS Account ID for the AFT account"
  type        = string
}


##################################################
# Ops OU and Ops  Account Variables
##################################################

variable "ops_ou_name" {
  description = "Name of the Ops organizational unit"
  type        = string
  default     = "Ops"
}

variable "ops_account_id" {
  description = "AWS Account ID for the OPS account"
  type        = string

}
