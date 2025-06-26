resource "aws_accessanalyzer_analyzer" "access_analyzer_external_organization" {
  analyzer_name = "control-tower-access-analyzer-external-organization"
  type          = "ORGANIZATION"
}

resource "aws_accessanalyzer_analyzer" "access_analyzer_unused_access_organization" {
  analyzer_name = "control-tower-access-analyzer-unused-access-organization"
  type          = "ORGANIZATION_UNUSED_ACCESS"

  configuration {
    unused_access {
      unused_access_age = 180
    }
  }
}

#############################################################
# IAM Access Analyzer validation
#############################################################
resource "aws_iam_role" "cross_account_role" {
  count = var.validate_iam_access_analyzer ? 1 : 0
  name  = "cross-account-invoke-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.external_account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
  depends_on = [aws_accessanalyzer_analyzer.access_analyzer_external_organization]
}
