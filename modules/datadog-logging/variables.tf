variable "datadog_api_key" {
  description = "Datadog API key for the forwarder Lambda. Get this from your Datadog account."
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP key for the forwarder Lambda. Get this from your Datadog account."
  type        = string
  sensitive   = true
}


variable "datadog_api" {
  description = "Datadog site (e.g., datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "https://api.datadoghq.eu/"
}

variable "datadog_site" {
  description = "Datadog site for the forwarder (e.g., datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "datadoghq.eu"
}

variable "organization_id" {
  description = "Organization ID for the Datadog Forwarder."
  type        = string

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


variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket containing CloudTrail logs to be forwarded."
  type        = string
  default     = "aws-controltower-logs"

}
