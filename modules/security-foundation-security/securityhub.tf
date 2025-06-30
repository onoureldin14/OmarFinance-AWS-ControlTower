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

resource "aws_securityhub_insight" "cirtical_high_risk_proudction_account" {
  filters {
    aws_account_id {
      comparison = "EQUALS"
      value      = var.aws_production_account_id
    }
    severity_label {
      comparison = "EQUALS"
      value      = "CRITICAL"
    }
    severity_label {
      comparison = "EQUALS"
      value      = "HIGH"
    }
  }

  group_by_attribute = "SeverityLabel"

  name = "Critical and High Risk Findings in Production Account"
}

resource "aws_securityhub_automation_rule" "elevate_security_and_management_findings" {
  description = "Elevate finding severity to CRITICAL when Security or Management findings are detected"
  rule_name   = "Elevate severity of findings that relate to Management or Security accounts"
  rule_order  = 1

  actions {
    finding_fields_update {
      severity {
        label   = "CRITICAL"
        product = "0.0"
      }
      note {
        text       = "This is a critical Account. Please review ASAP."
        updated_by = "sechub-automation"
      }

      types = ["Software and Configuration Checks/Industry and Regulatory Standards"]

      user_defined_fields = {
        key = "value"
      }
    }
    type = "FINDING_FIELDS_UPDATE"
  }

  criteria {
    aws_account_id {
      comparison = "EQUALS"
      value      = data.aws_caller_identity.current.account_id
    }
    aws_account_id {
      comparison = "EQUALS"
      value      = var.aws_management_account_id
    }
    severity_label {
      comparison = "EQUALS"
      value      = "HIGH"
    }

  }
}

resource "aws_cloudformation_stack" "ecr_continious_compliance" {
  name          = "aws-ecr-continuouscompliance"
  template_body = file("${path.module}/cf-templates/aws-ecr-continuouscompliance-v1.yaml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]
}

resource "aws_cloudformation_stack" "sechub_slack_integration" {
  count         = var.enable_sechub_slack_integration ? 1 : 0
  name          = "sechub-slack-integration"
  template_body = file("${path.module}/cf-templates/SecurityHub_to_AWSChatBot.yml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    SlackWorkSpaceID = var.slack_team_id
    SlackChannelID   = var.slack_channel_id
  }
}

resource "aws_cloudformation_stack" "sechub_findings_to_slack" {
  count         = var.enable_sechub_slack_integration ? 1 : 0
  name          = "sechub-findings-to-slack"
  template_body = file("${path.module}/cf-templates/SecurityHub_Critial_to_Slack.yml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]
  depends_on    = [aws_cloudformation_stack.sechub_slack_integration]
}
