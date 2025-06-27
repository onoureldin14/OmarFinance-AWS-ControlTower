############################################################
# Audit Manager Controls
############################################################
resource "aws_auditmanager_control" "config_controls" {
  name = "aws-config-controls"


  control_mapping_sources {
    source_name          = "CloudTrailEncryptionEnabled"
    source_set_up_option = "System_Controls_Mapping" # Automated
    source_type          = "AWS_Config"
    source_keyword = [{
      keyword_input_type = "INPUT_TEXT"
      keyword_value      = "CLOUD_TRAIL_ENCRYPTION_ENABLED"
    }]
  }
  control_mapping_sources {
    source_name          = "CloudTrailEnabled"
    source_set_up_option = "System_Controls_Mapping" # Automated
    source_type          = "AWS_Config"
    source_keyword = [{
      keyword_input_type = "INPUT_TEXT"
      keyword_value      = "CLOUD_TRAIL_ENABLED"
    }]
  }
  control_mapping_sources {
    source_name          = "S3AccountLevelPublicAccessBlocks"
    source_set_up_option = "System_Controls_Mapping" # Automated
    source_type          = "AWS_Config"
    source_keyword = [{
      keyword_input_type = "INPUT_TEXT"
      keyword_value      = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    }]

  }


}
