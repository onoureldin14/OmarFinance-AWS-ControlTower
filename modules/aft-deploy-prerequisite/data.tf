data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "external" "portfolio_id" {
  program = ["bash", "-c", <<-EOT
    id=$(aws servicecatalog list-portfolios \
      --region ${data.aws_region.current.region} \
      | jq -r '.PortfolioDetails[] | select(.DisplayName | contains("AWS Control Tower Account Factory Portfolio")) | .Id')
    jq -n --arg id "$id" '{"account_factory_portfolio_id":$id}'
  EOT
  ]
}
