locals {
  landing_zone_manifest = merge(
    {
      governedRegions = var.governed_regions

      organizationStructure = {
        security = {
          name = var.security_org_name
        }
        sandbox = {
          name = var.sandbox_org_name
        }
      }

      centralizedLogging = {
        accountId = aws_organizations_account.centralized_logging.id
        configurations = {
          loggingBucket = {
            retentionDays = var.logging_retention_days
          }
          accessLoggingBucket = {
            retentionDays = var.access_logging_retention_days
          }
          kmsKeyArn = aws_kms_key.logging_kms_key.arn
        }
        enabled = var.centralised_logging_enabled
      }

      securityRoles = {
        accountId = aws_organizations_account.security.id
      }

      accessManagement = {
        enabled = var.access_management_enabled
      }
    },

    var.backup_enabled ? {
      backup = {
        configurations = {
          centralBackup = {
            accountId = aws_organizations_account.central_backup[0].id
          }
          backupAdmin = {
            accountId = aws_organizations_account.backup_admin[0].id
          }
          kmsKeyArn = aws_kms_key.backup_kms_key[0].arn
        }
        enabled = true
      }
    } : {}
  )
}
