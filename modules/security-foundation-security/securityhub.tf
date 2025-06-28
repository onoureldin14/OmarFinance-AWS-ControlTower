resource "aws_securityhub_organization_configuration" "sec_hub_org_config" {
  auto_enable = true
}

resource "aws_securityhub_member" "members" {
  for_each   = var.enable_member_account_invites ? var.security_hub_member_invite : {}
  account_id = each.value.account_id
  email      = each.value.email
  depends_on = [aws_securityhub_organization_configuration.sec_hub_org_config]
  lifecycle {
    ignore_changes = [
      email, invite # Ignore changes to email to prevent unnecessary updates
    ]
  }
}

resource "aws_securityhub_finding_aggregator" "aws_securityhub_finding_aggregator" {
  linking_mode      = "SPECIFIED_REGIONS"
  specified_regions = var.securityhub_aggregator_specified_regions
}
