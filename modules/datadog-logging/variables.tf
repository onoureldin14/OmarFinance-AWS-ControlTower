variable "datadog_api_key" {
  description = "Datadog API key for the forwarder Lambda. Get this from your Datadog account."
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site (e.g., datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "datadoghq.eu"
}

variable "forwarder_stack_name" {
  description = "Name for the Datadog Forwarder CloudFormation stack."
  type        = string
  default     = "datadog-forwarder"
}

variable "forwarder_function_name" {
  description = "Name for the Datadog Forwarder Lambda function."
  type        = string
  default     = "datadog-forwarder"
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group to forward to Datadog."
  type        = string
  default     = "datadog-forwarder-log-group"
}


variable "mgt_account_cloudtrail_bucket_name" {
  description = "Name of the S3 bucket containing CloudTrail logs to be forwarded."
  type        = string
}

variable "mgt_account_cloudtrail_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt CloudTrail logs. Pass the output from the logging module."
  type        = string
}
