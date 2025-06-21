locals {
  landing_zone_manifest = merge(
    {
      governedRegions = var.governed_regions

      organizationStructure = {
        security = {
          name = var.security_org_name
        }
      }

      centralizedLogging = {
        accountId = var.logging_account_id
        configurations = {
          loggingBucket = {
            retentionDays = var.logging_retention_days
          }
          accessLoggingBucket = {
            retentionDays = var.access_logging_retention_days
          }
          kmsKeyArn = aws_kms_key.control_tower_kms_key[0].arn
        }
        enabled = var.centralised_logging_enabled
      }

      securityRoles = {
        accountId = var.security_account_id
      }

      accessManagement = {
        enabled = var.access_management_enabled
      }
    },

    var.backup_enabled ? {
      backup = {
        configurations = {
          centralBackup = {
            accountId = var.central_backup_account_id
          }
          backupAdmin = {
            accountId = var.backup_account_id
          }
          kmsKeyArn = aws_kms_key.control_tower_kms_key[1].arn
        }
        enabled = true
      }
    } : {}
  )
}
