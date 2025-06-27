data "aws_guardduty_detector" "security_detector" {}


resource "aws_guardduty_organization_configuration" "auto_enable" {
  auto_enable_organization_members = "ALL"
  detector_id                      = data.aws_guardduty_detector.security_detector.id
}

resource "aws_guardduty_organization_configuration_feature" "features" {
  for_each    = toset(local.guardduty_features)
  detector_id = data.aws_guardduty_detector.security_detector.id
  name        = each.key
  auto_enable = "ALL"

  dynamic "additional_configuration" {
    for_each = each.key == "EKS_RUNTIME_MONITORING" ? [1] : []
    content {
      name        = "EKS_ADDON_MANAGEMENT"
      auto_enable = "NEW"
    }
  }
  depends_on = [aws_guardduty_organization_configuration.auto_enable]
}
