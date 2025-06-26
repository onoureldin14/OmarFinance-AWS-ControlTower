resource "aws_organizations_organization" "org" {
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]

  aws_service_access_principals = concat(
    [
      "cloudtrail.amazonaws.com",
      "config.amazonaws.com",
      "controltower.amazonaws.com",
      "member.org.stacksets.cloudformation.amazonaws.com",
      "sso.amazonaws.com",
    ],
    var.delegated_security_services
  )

  feature_set = "ALL"
}
