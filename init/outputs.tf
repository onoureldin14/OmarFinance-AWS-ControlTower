output "aws_control_tower_landing_zone_role_arn" {
  description = "The ID of the AWS Control Tower Landing Zone"
  value       = aws_iam_role.controltower_admin.arn
}

output "controltower_stackset_role_arn" {
  value = aws_iam_role.controltower_stackset_role.arn
}
output "controltower_cloudtrail_role_arn" {
  value = aws_iam_role.cloudtrail_role.arn
}

output "controltower_config_aggregator_role" {
  value = aws_iam_role.config_aggregator_role.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}
