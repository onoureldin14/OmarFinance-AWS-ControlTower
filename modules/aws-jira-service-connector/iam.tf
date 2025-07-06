############################################################
# IAM Sync User
############################################################

variable "sqs_arns" {
  description = "List of SQS ARNs the user can access"
  type        = list(string)
}

resource "aws_iam_user" "sync_user" {
  name          = "Jira-SMSyncUser"
  force_destroy = true
}

resource "aws_iam_access_key" "sync_user_key" {
  user = aws_iam_user.sync_user.name
}

# --- Attach AWS Managed Policies ---
resource "aws_iam_user_policy_attachment" "aws_managed" {
  for_each = toset([
    "AWSServiceCatalogAdminReadOnlyAccess",
    "AmazonSSMReadOnlyAccess",
    "AWSSupportAccess"
  ])

  user       = aws_iam_user.sync_user.name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}

# --- Create Custom Policies ---

resource "aws_iam_policy" "securityhub_policy" {
  name        = "AWSSecurityHubPolicy"
  description = "Allows Security Hub updates and SQS access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage"],
        Resource = var.sqs_arns,
        Effect   = "Allow"
      },
      {
        Action   = ["securityhub:BatchUpdateFindings"],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "config_health_policy" {
  name        = "ConfigHealthSQSBaseline"
  description = "SQS access for Config Health"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage"],
      Resource = var.sqs_arns,
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "opscenter_policy" {
  name        = "OpsCenterExecutionPolicy"
  description = "SSM OpsCenter permissions"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "ssm:CreateOpsItem",
        "ssm:GetOpsItem",
        "ssm:UpdateOpsItem",
        "ssm:DescribeOpsItems"
      ],
      Resource = "*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "incident_policy" {
  name        = "AWSIncidentBaselinePolicy"
  description = "Permissions for AWS Incident Management"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "ssm-incidents:ListIncidentRecords",
        "ssm-incidents:GetIncidentRecord",
        "ssm-incidents:UpdateRelatedItems",
        "ssm-incidents:ListTimelineEvents",
        "ssm-incidents:GetTimelineEvent",
        "ssm-incidents:UpdateIncidentRecord",
        "ssm-incidents:ListRelatedItems",
        "ssm:ListOpsItemRelatedItems",
        "ssm-incidents:ListResponsePlans",
        "ssm-incidents:StartIncident"
      ],
      Resource = "*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "budgets_policy" {
  name        = "ViewBudgetsPolicy"
  description = "Allow budgets:ViewBudget on all resources"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["budgets:ViewBudget"],
      Resource = "*",
      Effect   = "Allow"
    }]
  })
}

# --- Attach Custom Policies ---
resource "aws_iam_user_policy_attachment" "custom_policies" {
  for_each = {
    securityhub  = aws_iam_policy.securityhub_policy.arn
    confighealth = aws_iam_policy.config_health_policy.arn
    opscenter    = aws_iam_policy.opscenter_policy.arn
    incident     = aws_iam_policy.incident_policy.arn
    budgets      = aws_iam_policy.budgets_policy.arn
  }

  user       = aws_iam_user.sync_user.name
  policy_arn = each.value
}

############################################################
# IAM End User
############################################################

resource "aws_iam_user" "end_user" {
  name          = "Jira-EndUser"
  force_destroy = true
}

resource "aws_iam_access_key" "end_user_key" {
  user = aws_iam_user.end_user.name
}

# --- Attach AWS Managed Policies ---
resource "aws_iam_user_policy_attachment" "end_user_managed" {
  for_each = toset([
    "AWSServiceCatalogEndUserFullAccess",
    "AmazonEC2ReadOnlyAccess",
    "AmazonS3ReadOnlyAccess"
  ])

  user       = aws_iam_user.end_user.name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}

# --- StackSet Inline Policy ---
resource "aws_iam_user_policy" "stackset_inline" {
  name = "StackSetPolicy"
  user = aws_iam_user.end_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudformation:DescribeStackSet",
          "cloudformation:ListStackInstances",
          "cloudformation:ListStackSetOperations",
          "cloudformation:GetTemplateSummary"
        ],
        Resource = "*"
      }
    ]
  })
}
