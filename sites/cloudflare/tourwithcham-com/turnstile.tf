resource "cloudflare_turnstile_widget" "inquiry" {
  account_id = var.cloudflare_account_id
  name       = local.turnstile_widget_name
  domains = [
    local.domain,
    local.pages_domain,
  ]
  mode = "managed"
}
