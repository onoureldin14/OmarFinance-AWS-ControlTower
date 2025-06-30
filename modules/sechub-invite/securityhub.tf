resource "aws_securityhub_account" "invitee" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_securityhub_invite_accepter" "invitee" {
  depends_on = [aws_securityhub_account.invitee]
  master_id  = var.aws_securityhub_admin_account_id
  lifecycle {
    prevent_destroy = true
  }
}
