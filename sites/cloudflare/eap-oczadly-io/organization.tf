data "cloudflare_zero_trust_organization" "current" {
  account_id = var.cloudflare_account_id
}

resource "cloudflare_zero_trust_organization" "site" {
  account_id  = var.cloudflare_account_id
  name        = local.domain
  auth_domain = data.cloudflare_zero_trust_organization.current.auth_domain

  login_design = {
    background_color = "#0b0f0e"
    text_color       = "#e3e3e3"
    logo_path        = "https://oczadly.io/images/logo-avatar.png"
    header_text      = "MEMBER EARLY ACCESS"
    footer_text      = "Explore production-ready solutions before they reach oczadly.io."
  }
}
