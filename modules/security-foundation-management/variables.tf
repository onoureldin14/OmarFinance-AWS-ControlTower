variable "validate_org_root_features" {
  description = "Flag to enable org root feature validation"
  type        = bool
  default     = false
}

variable "aws_security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
}
