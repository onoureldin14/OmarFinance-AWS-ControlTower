data "aws_caller_identity" "current" {}

data "aws_iam_role" "audit_administrator_role" {
  name = "aws-controltower-AuditAdministratorRole"
}
