## 🧪 2. CT.APIGATEWAY.PR.4 — Require API Gateway V2 stage to have access logging enabled
### ✅ Misconfigured resource:
#### Create an API Gateway Stage without access logging enabled.

resource "aws_apigatewayv2_api" "example" {
  name          = "test-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "non_compliant" {
  api_id      = aws_apigatewayv2_api.example.id
  name        = "$default"
  auto_deploy = true
  # ❌ No access logging block provided
}