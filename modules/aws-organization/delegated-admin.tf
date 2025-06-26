resource "null_resource" "enable_service_access" {
  for_each = toset(var.delegated_security_services)

  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal ${each.key}"
  }
}

resource "aws_organizations_delegated_administrator" "delegated_admins" {
  for_each          = var.enable_security_account_delegated_admin ? toset(var.delegated_security_services) : null
  account_id        = var.aws_security_account_id
  service_principal = each.key

  depends_on = [null_resource.enable_service_access]
}
