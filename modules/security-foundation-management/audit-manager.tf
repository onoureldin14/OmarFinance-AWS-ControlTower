resource "aws_auditmanager_account_registration" "registeration" {
  deregister_on_destroy = true
}

resource "aws_auditmanager_organization_admin_account_registration" "security_account" {
  admin_account_id = var.aws_security_account_id
  depends_on       = [aws_auditmanager_account_registration.registeration]
}
