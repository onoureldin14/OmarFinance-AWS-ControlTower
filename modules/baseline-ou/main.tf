resource "aws_cloudformation_stack" "enable_baseline" {
  name          = "RegisterOU"
  template_body = file("${path.module}/cf-templates/EnableBaselineCFN.yaml")

  parameters = {
    CTBaselineId   = data.external.baselines.result["ct_baseline_arn"]
    OUId           = var.organizational_unit_id
    OrganizationId = var.organization_id
    IdCBaselineId  = data.external.baselines.result["idc_baseline_arn"]
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]
}
