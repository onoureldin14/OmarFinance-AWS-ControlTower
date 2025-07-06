output "sync_user_credentials" {
  value = {
    access_key_id     = aws_iam_access_key.sync_user_key.id
    secret_access_key = aws_iam_access_key.sync_user_key.secret
  }

  sensitive = true
}

output "end_user_credentials" {
  value = {
    access_key_id     = aws_iam_access_key.end_user_key.id
    secret_access_key = aws_iam_access_key.end_user_key.secret
  }

  sensitive = true
}
