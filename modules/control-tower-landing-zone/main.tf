resource "aws_controltower_landing_zone" "omarfinance" {
  manifest_json = jsonencode(local.landing_zone_manifest)
  version       = var.aws_control_tower_landing_zone_version
}
