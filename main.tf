module "control_tower_landing_zone" {
  source              = "./modules/control-tower-landing-zone"
  governed_regions    = var.governed_regions
  security_account_id = module.organization.account_ids["security"]
  logging_account_id  = module.organization.account_ids["logging"]
  security_org_name   = var.security_ou_name
  ######################################################
  # Part 2 # Control Tower Landing Zone Controls
  ######################################################
  enable_controls = var.enable_controls
  controls        = local.controls
  ou_arns         = module.organization.ou_arns

}

module "organization" {
  source                = "./modules/aws-organization"
  organization_accounts = local.organization_accounts
  organizational_units  = local.organizational_units
}
