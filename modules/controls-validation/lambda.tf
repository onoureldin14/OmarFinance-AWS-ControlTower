## 🚫 3. CT.LAMBDA.PV.2 — Require Lambda function URLs to be accessible only from your AWS account
### ✅ Misconfigured resource:
#### Create a Lambda Function URL with public access.

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "attach_lambda_logs"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "local_file" "lambda_handler" {
  filename = "${path.module}/lambda/main.py"
  content  = <<-EOT
    def handler(event, context):
        return {
            'statusCode': 200,
            'body': 'Hello from inline Lambda!'
        }
  EOT
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = local_file.lambda_handler.filename
  output_path = "${path.module}/lambda/lambda.zip"
}


resource "aws_lambda_function" "inline_lambda" {
  function_name = "inline-lambda-non-compliant"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "main.handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_function_url" "public" {
  count              = var.enable_detective_controls ? 1 : 0
  function_name      = aws_lambda_function.inline_lambda.function_name
  authorization_type = "NONE" # ❌ Publicly accessible
}
