module "get_cloudtrail_bucket" {
  source           = "digitickets/cli/aws"
  version          = "6.1.0"
  profile          = "logging"
  aws_cli_commands = ["s3api", "list-buckets"]
  aws_cli_query    = "Buckets[?starts_with(Name, `${var.cloudtrail_bucket_name}`)].Name"
}

data "aws_caller_identity" "current" {}



data "aws_iam_policy_document" "cloudtrail_logs" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.cloudtrail_bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]]
    }
  }
}

data "aws_iam_roles" "datadog_forwarder" {
  name_regex = "^${var.forwarder_stack_name}-.*$"
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}
