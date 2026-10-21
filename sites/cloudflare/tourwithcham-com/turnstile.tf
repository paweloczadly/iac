resource "cloudflare_turnstile_widget" "inquiry" {
  account_id = var.cloudflare_account_id
  name       = local.turnstile_widget_name
  domains = [
    local.pages_domain,
    local.domain,
  ]
  mode = "managed"
}
