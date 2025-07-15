resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = "datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn = aws_secretsmanager_secret.dd_api_key.arn
    DdSite            = var.datadog_site
    FunctionName      = var.forwarder_function_name
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
  depends_on   = [datadog_integration_aws_account.datadog_integration]
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${module.get_cloudtrail_bucket.result[0]}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.get_cloudtrail_bucket.result[0]

  lambda_function {
    lambda_function_arn = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.organization_id}/AWSLogs/"
    filter_suffix       = ".gz"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
