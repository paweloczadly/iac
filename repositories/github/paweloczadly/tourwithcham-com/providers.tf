terraform {
  required_version = ">= 1.10.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.8.3"
    }
  }
}

provider "github" {
  owner = "paweloczadly"

  app_auth {
    id              = var.iac_oczadly_io_github_app_app_id
    installation_id = var.iac_oczadly_io_github_app_installation_id
    pem_file        = base64decode(var.iac_oczadly_io_github_app_pem)
  }
}
