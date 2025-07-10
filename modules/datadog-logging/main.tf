resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = var.forwarder_stack_name
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"

  parameters = {
    DdApiKey     = var.datadog_api_key
    DdSite       = var.datadog_site
    FunctionName = var.forwarder_function_name
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]
}

data "aws_iam_policy_document" "cloudtrail_logs" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.mgt_account_cloudtrail_bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudformation_stack.datadog_forwarder.outputs["ForwarderArn"]]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  bucket     = var.mgt_account_cloudtrail_bucket_name
  policy     = data.aws_iam_policy_document.cloudtrail_logs.json
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}


data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [var.mgt_account_cloudtrail_kms_key_arn]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudformation_stack.datadog_forwarder.outputs["ForwarderArn"]]
    }
  }
}

resource "aws_kms_key_policy" "cloudtrail" {
  key_id     = var.mgt_account_cloudtrail_kms_key_arn
  policy     = data.aws_iam_policy_document.cloudtrail_kms.json
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}

resource "aws_cloudwatch_log_subscription_filter" "forwarder" {
  name            = "datadog-forwarder"
  log_group_name  = var.cloudwatch_log_group_name
  filter_pattern  = ""
  destination_arn = aws_cloudformation_stack.datadog_forwarder.outputs["ForwarderArn"]
  role_arn        = aws_cloudformation_stack.datadog_forwarder.outputs["ForwarderRoleArn"]
}
