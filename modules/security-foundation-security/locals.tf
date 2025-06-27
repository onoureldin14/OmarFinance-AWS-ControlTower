locals {
  selected_runtime_feature = var.use_eks_runtime_monitoring ? "EKS_RUNTIME_MONITORING" : "RUNTIME_MONITORING"

  guardduty_features = [
    "S3_DATA_EVENTS",
    "EKS_AUDIT_LOGS",
    "RDS_LOGIN_EVENTS",
    "LAMBDA_NETWORK_LOGS",
    "EBS_MALWARE_PROTECTION",
    local.selected_runtime_feature
  ]
}
