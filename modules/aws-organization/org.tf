resource "aws_organizations_organization" "org" {
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "controltower.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
    "access-analyzer.amazonaws.com"
  ]
  feature_set = "ALL"
}
