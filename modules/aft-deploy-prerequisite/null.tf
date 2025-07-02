resource "null_resource" "get_account_factory_portfolio_id" {
  provisioner "local-exec" {
    command = <<EOT
      aws servicecatalog list-portfolios \
        --region ${data.aws_region.current.region}  \
        | jq -r '.PortfolioDetails[] | select(.DisplayName | contains("AWS Control Tower Account Factory Portfolio")) | .Id' \
        | tr -d '\n' > portfolio_id.txt
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}
