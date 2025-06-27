resource "aws_guardduty_detector" "detector" {
  enable = true
}

resource "aws_guardduty_organization_admin_account" "security_account" {
  depends_on       = [aws_guardduty_detector.detector]
  admin_account_id = var.aws_security_account_id
}
