output "datadog_forwarder_arn" {
  value = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
}

output "datadog_forwarder_role_arn" {
  value = data.aws_iam_roles.datadog_forwarder.arns
}
