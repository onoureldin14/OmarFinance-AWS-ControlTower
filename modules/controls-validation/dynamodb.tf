## 🔍 1. **SH.DynamoDB.1** — *DynamoDB should auto scale capacity with demand*
### ✅ Misconfigured resource:
####  Create a DynamoDB table with provisioned capacity instead of on-demand.

resource "aws_dynamodb_table" "non_compliant" {
  name           = "dynamodb-non-compliant"
  billing_mode   = "PROVISIONED" # ❌ should be PAY_PER_REQUEST
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
