############################################################
# Audit Manager Assessment
############################################################

resource "aws_auditmanager_assessment" "assessment" {
  name = "terraform-audit-assessment"

  assessment_reports_destination {
    destination      = "s3://${aws_s3_bucket.audit_manager_bucket.id}"
    destination_type = "S3"
  }

  framework_id = aws_auditmanager_framework.frammework.id

  roles {
    role_arn  = data.aws_iam_role.audit_administrator_role.arn
    role_type = "PROCESS_OWNER"
  }

  scope {
    aws_accounts {
      id = data.aws_caller_identity.current.account_id
    }
    aws_services {
      service_name = "S3"
    }
  }
}
