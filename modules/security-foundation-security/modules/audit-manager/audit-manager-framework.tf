############################################################
# Audit Manager Frammework
############################################################

resource "aws_auditmanager_framework" "frammework" {
  name = "terraform-audit-framework"

  control_sets {
    name = "terraform-audit-controls-set"
    controls {
      id = aws_auditmanager_control.config_controls.id
    }
  }
}
