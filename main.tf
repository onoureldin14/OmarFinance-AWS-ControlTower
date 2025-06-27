module "organization" {
  source                                  = "./modules/aws-organization"
  organization_accounts                   = local.organization_accounts
  organizational_units                    = local.organizational_units
  enable_security_account_delegated_admin = true
  aws_security_account_id                 = var.security_account_id

}


module "control_tower_landing_zone" {
  source              = "./modules/control-tower-landing-zone"
  governed_regions    = var.governed_regions
  security_account_id = module.organization.account_ids["security"]
  logging_account_id  = module.organization.account_ids["logging"]
  security_org_name   = var.security_ou_name
  ######################################################
  # PART 2 # Control Tower Landing Zone Controls
  ######################################################
  enable_controls = var.enable_controls
  controls        = local.controls
  ou_arns         = module.organization.ou_arns
  depends_on      = [module.organization]

}

############################################################################
# PART 2: Control Tower Landing Zone Controls
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

############################################################
# PART 3 # Control Tower Landing Zone Security Foundation
############################################################



module "security_foundation_management" {
  source                     = "./modules/security-foundation-management"
  validate_org_root_features = false
  aws_security_account_id    = var.security_account_id
  depends_on                 = [module.control_tower_landing_zone, module.organization]
}

#######################################################################################
# DONT FORGET TO ENABLE SECUIRTY ACCOUNT AS DELEGATED ADMIN IN THE ORGANIZATION MODULE
#######################################################################################

module "security_foundation_security" {
  source = "./modules/security-foundation-security"
  providers = {
    aws = aws.security
  }
  validate_iam_access_analyzer = false
  depends_on                   = [module.control_tower_landing_zone, module.organization, module.security_foundation_management]
}
