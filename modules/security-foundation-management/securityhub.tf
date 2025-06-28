resource "aws_securityhub_account" "sec_hub" {}

resource "aws_securityhub_organization_admin_account" "sec_hub_admin" {
  depends_on       = [aws_securityhub_account.sec_hub]
  admin_account_id = var.aws_security_account_id
}
