terraform {
  backend "s3" {
    # Bucket Created by the OmarFinance Application
    bucket       = "tfstate-omarfinance-caf1725c"
    key          = "control-tower-landing-zone-init/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
