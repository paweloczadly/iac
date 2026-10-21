terraform {
  required_version = ">= 1.10.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.22.0"
    }
    resend = {
      source  = "y0n0zawa/resend"
      version = "~> 1.0.1"
    }
  }
}

provider "cloudflare" {}

provider "resend" {
  api_key = var.resend_api_key
}
