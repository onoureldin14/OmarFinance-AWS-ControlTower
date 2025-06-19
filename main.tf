module "control_tower_landing_zone" {
  source                 = "./modules/control-tower-landing-zone"
  security_account_email = var.security_account_email
  sandbox_account_email  = var.sandbox_account_email
  logging_account_email  = var.logging_account_email
}
