locals {
  organizational_units = {
    "Product" = {
      name = var.product_ou_name
    }
  }
  organization_accounts = {
    security = {
      name  = var.security_account_name
      email = var.security_account_email
    }
    logging = {
      name  = var.logging_account_name
      email = var.logging_account_email

    }
    production = {
      name  = var.production_account_name
      email = var.production_account_email
      ou    = local.organizational_units.Product.name
    }
  }

  controls = {
    detective_controls_dynamodb = {
      alias              = "SH.DynamoDB.1"
      control_identifier = "keijcuz1a7n70grfn62tb2jj"
      target_ou_key      = var.product_ou_name
    }
    proactive_controls_apigw = {
      alias              = "CT.APIGATEWAY.PR.4"
      control_identifier = "ro9dk09errhg8vo6flro4o7n"
      target_ou_key      = var.product_ou_name
    }
    preventive_controls_lambda = {
      alias              = "CT.LAMBDA.PV.2"
      control_identifier = "aksh80tizisat4i4ou8qg1hdy"
      target_ou_key      = var.product_ou_name
    }


  }

}
