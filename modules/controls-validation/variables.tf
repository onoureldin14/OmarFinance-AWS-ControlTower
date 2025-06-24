variable "enable_detective_controls" {
  description = "Enable Detective controls, since Detective controls cause terraform to fail if enabled"
  type        = bool
  default     = false
}
