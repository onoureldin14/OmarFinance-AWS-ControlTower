
resource "aws_servicecatalog_principal_portfolio_association" "aft_execution_role_association" {
  portfolio_id   = data.external.portfolio_id.result.account_factory_portfolio_id
  principal_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSAFTExecution"
  principal_type = "IAM"
}
