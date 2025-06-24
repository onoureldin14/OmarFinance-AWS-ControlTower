## 🧪 2. CT.APIGATEWAY.PR.4 — Require API Gateway V2 stage to have access logging enabled
### ✅ Misconfigured resource:
#### Create an API Gateway Stage without access logging enabled.

resource "aws_cloudformation_stack" "non_compliant_apigw" {
  name          = "proactive-control-validation-non-compliant-apigw"
  template_body = file("${path.module}/cf-templates/non_compliant_apigw.yaml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]
}