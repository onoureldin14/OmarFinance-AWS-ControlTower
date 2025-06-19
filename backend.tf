terraform {
  backend "s3" {
    bucket       = "tfstate-control-tower-67cd7472"
    key          = "control-tower-landing-zone/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
