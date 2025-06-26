module "organization" {
  source                = "./modules/aws-organization"
  organization_accounts = local.organization_accounts
  organizational_units  = local.organizational_units
}


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
  depends_on      = [module.organization]

}

############################################################################
# UnComment out this module block if you are using a production profile
# and want to validate the Control Tower Landing Zone Controls
############################################################################


# module "control_tower_controls_validation" {
#   count = var.validate_controls ? 1 : 0
#   providers = {
#     aws = aws.production
#   }
#   source = "./modules/controls-validation"
#   depends_on = [ module.control_tower_landing_zone ]
# }

module "security_foundation" {
  source                       = "./modules/security-foundation"
  validate_iam_access_analyzer = false
  validate_org_root_features   = false
  depends_on                   = [module.control_tower_landing_zone]
}
