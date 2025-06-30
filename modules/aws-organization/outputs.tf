output "organization_id" {
  description = "The ID of the AWS Organization"
  value       = aws_organizations_organization.org.id
}


output "root_organization_id" {
  description = "The ID of the Root OU of AWS Organization"
  value       = aws_organizations_organization.org.roots[0].id
}

output "account_ids" {
  description = "Map of account names to their AWS account IDs"
  value = {
    for acc_key, acc in aws_organizations_account.accounts :
    acc_key => acc.id
  }
}

output "ou_ids" {
  description = "Map of OU names to their AWS IDs"
  value = {
    for ou_name, ou_resource in aws_organizations_organizational_unit.ou :
    ou_name => ou_resource.id
  }
}

output "ou_names" {
  description = "The names of the organizational units created"
  value = {
    for k, ou in aws_organizations_organizational_unit.ou : k => ou.name
  }
}

output "ou_arns" {
  description = "The ARNs of the organizational units created"
  value = {
    for k, ou in aws_organizations_organizational_unit.ou : k => ou.arn
  }
}
