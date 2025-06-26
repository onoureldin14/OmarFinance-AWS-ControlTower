variable "external_account_id" {
  type    = string
  default = "123456789012" # replace with actual external account ID
}

variable "validate_iam_access_analyzer" {
  description = "Flag to enable or disable IAM Access Analyzer validation"
  type        = bool
  default     = false
}
