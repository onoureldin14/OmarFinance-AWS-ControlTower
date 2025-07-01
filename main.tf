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
  validate_iam_access_analyzer             = false
  security_hub_member_invite               = local.security_hub_member_invite
  securityhub_aggregator_specified_regions = var.securityhub_aggregator_specified_regions
  aws_management_account_id                = data.aws_caller_identity.current.account_id
  aws_production_account_id                = var.production_account_id
  enable_sechub_slack_integration          = true
  slack_channel_id                         = var.slack_channel_id
  slack_team_id                            = var.slack_team_id
  depends_on                               = [module.control_tower_landing_zone, module.organization, module.security_foundation_management]
}

############################################################
# PART 3 # Establishing a Baseline OU for Platform OU
############################################################

module "baseline_ou" {
  source                 = "./modules/baseline-ou"
  organizational_unit_id = module.organization.ou_ids["Platform"]
  organization_id        = module.organization.organization_id
  depends_on             = [module.organization]
}


############################################################
# PART 4 # Account Factory Pipeline
############################################################


module "aft_pipeline" {
  source = "git::https://github.com/aws-ia/terraform-aws-control_tower_account_factory.git?ref=1.14.1"
  # Required Variables
  ct_management_account_id    = data.aws_caller_identity.current.account_id
  log_archive_account_id      = var.logging_account_id
  audit_account_id            = var.security_account_id
  aft_management_account_id   = var.aft_account_id
  ct_home_region              = var.aws_region
  tf_backend_secondary_region = var.aws_secondary_region

  # Terraform variables
  terraform_version      = "1.6.0"
  terraform_distribution = "oss"

  # VCS Vars
  vcs_provider                                  = "github"
  account_request_repo_name                     = "${var.github_organization}/${var.company_name}-aft-account-request"
  global_customizations_repo_name               = "${var.github_organization}/${var.company_name}-aft-global-customizations"
  account_customizations_repo_name              = "${var.github_organization}/${var.company_name}-aft-account-customizations"
  account_provisioning_customizations_repo_name = "${var.github_organization}/${var.company_name}-aft-account-provisioning-customizations"

  # AFT Feature flags
  aft_feature_cloudtrail_data_events      = false
  aft_feature_enterprise_support          = false
  aft_feature_delete_default_vpcs_enabled = true

  # AFT Additional Configurations
  aft_enable_vpc                            = false
  backup_recovery_point_retention           = 1
  log_archive_bucket_object_expiration_days = 1
}



#######################################################################################
# OPTIONAL MODULE FOR SECURITY HUB INVITE ACCEPTOR
# This module is used to accept Security Hub invitations from the Security Account
#######################################################################################

# module "securityhub_invite_master_account" {
#   count                             = var.enable_invite_acceptors ? 1 : 0
#   source                            = "./modules/sechub-invite"
#   aws_securityhub_admin_account_id  = var.security_account_id
#   depends_on                        = [module.security_foundation_security]
# }

# module "securityhub_invite_logging_account" {
#   count                             = var.enable_invite_acceptors ? 1 : 0
#   source                            = "./modules/sechub-invite"
#     providers = {
#     aws = aws.logging
#   }
#   aws_securityhub_admin_account_id  = var.security_account_id
#   depends_on                        = [module.security_foundation_security]
# }

# module "securityhub_invite_product_account" {
#   count                             = var.enable_invite_acceptors ? 1 : 0
#   source                            = "./modules/sechub-invite"
#       providers = {
#     aws = aws.production
#   }
#   aws_securityhub_admin_account_id  = var.security_account_id
#   depends_on                        = [module.security_foundation_security]
# }
