resource "aws_organizations_organizational_unit" "ou" {
  for_each  = var.organizational_units
  name      = each.value.name
  parent_id = each.value.parent_id != null ? each.value.parent_id : aws_organizations_organization.org.roots[0].id
}
