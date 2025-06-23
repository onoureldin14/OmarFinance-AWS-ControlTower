resource "aws_controltower_control" "control" {
  for_each = local.controls_to_apply

  control_identifier = "arn:aws:controlcatalog:::control/${each.value.control_identifier}"
  target_identifier  = each.value.target_identifier
  depends_on         = [aws_controltower_landing_zone.control_tower_landing_zone]
}
