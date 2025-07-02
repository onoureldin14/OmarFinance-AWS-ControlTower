data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "external" "portfolio_id" {
  program = ["bash", "-c", "jq -n --arg id $(cat portfolio_id.txt | tr -d '\\n') '{account_factory_portfolio_id: $id}'"]
}
