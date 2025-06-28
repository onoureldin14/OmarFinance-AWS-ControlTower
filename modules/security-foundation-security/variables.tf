variable "external_account_id" {
  type    = string
  default = "123456789012" # replace with actual external account ID
}

variable "validate_iam_access_analyzer" {
  description = "Flag to enable or disable IAM Access Analyzer validation"
  type        = bool
  default     = false
}

variable "use_eks_runtime_monitoring" {
  description = "Whether to use EKS_RUNTIME_MONITORING instead of RUNTIME_MONITORING"
  type        = bool
  default     = true
}

variable "enable_member_account_invites" {
  description = "Whether to enable inviting member accounts to Security Hub"
  type        = bool
  default     = true
}

variable "security_hub_member_invite" {
  description = "Map of Security Hub member accounts to invite"
  type = map(object({
    account_id = string
    email      = string
  }))
}
