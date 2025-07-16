data "aws_kms_key" "by_alias" {
  key_id = "alias/control-tower-kms-key-logging"
}

data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    actions = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = ["*"]
  }

  statement {
    sid    = "Allow Config to use KMS for encryption"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    resources = [data.aws_kms_key.by_alias.arn]
  }

  statement {
    sid    = "Allow CloudTrail to use KMS for encryption"
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = [data.aws_kms_key.by_alias.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:eu-west-1:${data.aws_caller_identity.current.account_id}:trail/aws-controltower-BaselineCloudTrail"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
      ]
    }
  }

  statement {
    sid    = "AllowDatadogForwarderFromMemberAccount"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    principals {
      type        = "AWS"
      identifiers = [tolist(var.datadog_forwarder_role_arn)[0]] # This should be the ARN of the Datadog forwarder Lambda
    }

    resources = ["*"]
  }
}

resource "aws_kms_key_policy" "cloudtrail" {
  key_id = data.aws_kms_key.by_alias.arn
  policy = data.aws_iam_policy_document.cloudtrail_kms.json
}
