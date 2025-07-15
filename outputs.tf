output "aws_control_tower_landing_zone_id" {
  description = "The ID of the AWS Control Tower Landing Zone"
  value       = module.control_tower_landing_zone.aws_control_tower_landing_zone_id
}

output "ct_baseline_arn" {
  description = "The ARN of the AWS Control Tower baseline"
  value       = module.baseline_ou.ct_baseline_arn

}

output "idc_baseline_arn" {
  description = "The ARN of the IDC Baseline"
  value       = module.baseline_ou.idc_baseline_arn
}

output "account_factory_portfolio_id" {
  description = "AWS Control Tower Account Factory Portfolio"
  value       = module.aft_deploy_prerequisite.portfolio_id
}


# output "datadog_forwarder_arn" {
#   value =  module.datadog_logging.datadog_forwarder_arn
# }
