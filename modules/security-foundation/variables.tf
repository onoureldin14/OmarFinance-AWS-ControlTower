variable "external_account_id" {
  type    = string
  default = "123456789012" # replace with actual external account ID
}

variable "validate_iam_access_analyzer" {
  description = "Flag to enable or disable IAM Access Analyzer validation"
  type        = bool
  default     = false
}

variable "enable_org_root_features" {
  description = "Flag to enable or disable AWS Organizations root features (e.g `RootCredentialsManagement` and `RootSessions`)."
  type        = bool
  default     = false
}


variable "validate_org_root_features" {
  description = "Flag to enable org root feature validation"
  type        = bool
  default     = false
}
