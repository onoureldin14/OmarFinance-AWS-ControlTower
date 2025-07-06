resource "null_resource" "enable_service_access" {
  for_each = toset(var.delegated_security_services)

  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal ${each.key}"
  }
}

resource "aws_organizations_delegated_administrator" "delegated_admins" {
  for_each = var.enable_security_account_delegated_admin ? {
    for svc in var.delegated_security_services :
    svc => svc
    if !contains([
      "guardduty.amazonaws.com",
      "malware-protection.guardduty.amazonaws.com",
      "auditmanager.amazonaws.com",
      "securityhub.amazonaws.com",
    ], svc)
  } : {}

  account_id        = var.aws_security_account_id
  service_principal = each.key

  depends_on = [null_resource.enable_service_access]
}


resource "null_resource" "enable_aft_service_access" {
  for_each = toset(var.aft_services)
  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal ${each.key}"
  }
}


resource "aws_organizations_delegated_administrator" "aft_delegated_admin" {
  for_each = var.enable_aft_delegated_admin ? {
    for idx, svc in var.aft_services : idx => svc
  } : {}
  account_id        = var.aws_aft_account_id
  service_principal = each.value

  depends_on = [null_resource.enable_aft_service_access]
}


resource "null_resource" "enable_ops_service_access" {
  for_each = toset(var.ops_services)
  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal ${each.key}"
  }
}


resource "aws_organizations_delegated_administrator" "ops_delegated_admin" {
  for_each = var.enable_ops_delegated_admin ? {
    for idx, svc in var.ops_services : idx => svc
  } : {}
  account_id        = var.aws_ops_account_id
  service_principal = each.value

  depends_on = [null_resource.enable_aft_service_access]
}
