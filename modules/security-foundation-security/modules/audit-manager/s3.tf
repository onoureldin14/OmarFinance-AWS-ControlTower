############################################################
# S3 For Audit Manager Assessment
############################################################

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "audit_manager_bucket" {
  bucket = "audit-manager-bucket-${random_id.suffix.hex}"

  tags = {
    Name = "aws-audit-manager"
  }
}
