terraform {
  backend "s3" {
    bucket       = "tfstate-control-tower-e497cc4d"
    key          = "control-tower-landing-zone/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
