resource "aws_kms_key" "control_tower_kms_key" {
  count                   = var.backup_enabled ? 2 : 1
  description             = "Control Tower symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
}

resource "aws_kms_alias" "control_tower_kms_key_alias" {
  count         = var.backup_enabled ? 2 : 1
  name          = var.backup_enabled ? "alias/control-tower-kms-key-${count.index}" : "alias/control-tower-kms-key"
  target_key_id = aws_kms_key.control_tower_kms_key[count.index].key_id
}

resource "aws_kms_key_policy" "control_tower_kms_key_policy" {
  count  = length(aws_kms_key.control_tower_kms_key)
  key_id = aws_kms_key.control_tower_kms_key[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Config to use KMS for encryption"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.control_tower_kms_key[count.index].id}"
      },
      {
        Sid    = "Allow CloudTrail to use KMS for encryption"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.control_tower_kms_key[count.index].id}"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/aws-controltower-BaselineCloudTrail"
          }
          StringLike = {
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
          }
        }
      }
    ]
  })
}
