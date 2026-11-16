resource "cloudflare_turnstile_widget" "inquiry" {
  account_id = var.cloudflare_account_id
  name       = local.turnstile_widget_name
  domains = [
    local.pages_domain,
    local.domain,
  ]
  mode = "managed"
}

resource "cloudflare_turnstile_widget" "staging_inquiry" {
  account_id = var.cloudflare_account_id
  name       = local.staging_turnstile_widget_name
  domains = [
    local.staging_pages_domain,
    local.staging_domain,
  ]
  mode = "managed"
}
