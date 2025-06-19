resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "controltower.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com"

  ]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set          = "ALL"
}

resource "aws_organizations_account" "security" {
  name       = "Security Account"
  email      = var.security_account_email
  depends_on = [aws_organizations_organization.org]
}

resource "aws_organizations_account" "sandbox" {
  name       = "Sandbox Account"
  email      = var.sandbox_account_email
  depends_on = [aws_organizations_organization.org]
}

resource "aws_organizations_account" "centralized_logging" {
  name       = "Centralized Logging"
  email      = var.logging_account_email
  depends_on = [aws_organizations_organization.org]
}

resource "aws_organizations_account" "backup_admin" {
  count      = var.backup_enabled ? 1 : 0
  name       = "Backup Admin"
  email      = var.backup_account_email
  depends_on = [aws_organizations_organization.org]

}

resource "aws_organizations_account" "central_backup" {
  count      = var.backup_enabled ? 1 : 0
  name       = "Central Backup"
  email      = var.central_backup_account_email
  depends_on = [aws_organizations_organization.org]

}
