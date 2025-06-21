resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-control-tower-${random_id.suffix.hex}"

  tags = {
    Name = "Terraform State Bucket"
  }
}
