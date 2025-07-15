terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
  required_version = ">= 0.13"
}


provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api
}
