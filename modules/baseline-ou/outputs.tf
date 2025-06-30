output "ct_baseline_arn" {
  description = "The ARN of the AWS Control Tower baseline"
  value       = data.external.baselines.result["ct_baseline_arn"]
}

output "idc_baseline_arn" {
  description = "The ARN of the IDC Baseline"
  value       = data.external.baselines.result["idc_baseline_arn"]

}
