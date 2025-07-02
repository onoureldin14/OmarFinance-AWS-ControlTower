output "portfolio_id" {
  description = "AWS Control Tower Account Factory Portfolio"
  value       = data.external.portfolio_id.result.account_factory_portfolio_id
}
