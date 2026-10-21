resource "cloudflare_email_routing_dns" "site" {
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_email_routing_address" "inquiries" {
  account_id = var.cloudflare_account_id
  email      = var.inquiry_notification_destination
}

resource "cloudflare_email_routing_rule" "inquiries" {
  count = var.enable_inquiry_email_routing_rule ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = "Forward ${local.inquiry_email_address} to Chamara"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = local.inquiry_email_address
  }]

  actions = [{
    type  = "forward"
    value = [var.inquiry_notification_destination]
  }]

  depends_on = [cloudflare_email_routing_address.inquiries]

  lifecycle {
    precondition {
      condition     = cloudflare_email_routing_address.inquiries.verified != null
      error_message = "The inquiry email destination must be verified in Cloudflare before enabling its routing rule."
    }
  }
}

resource "resend_domain" "site" {
  name           = local.domain
  region         = "eu-west-1"
  open_tracking  = false
  click_tracking = false
  tls            = "enforced"
}

resource "resend_api_key" "pages" {
  name       = "tourwithcham-pages"
  permission = "sending_access"
  domain_id  = resend_domain.site.id
}

resource "cloudflare_dns_record" "resend" {
  for_each = var.enable_resend_domain_verification ? {
    for record in resend_domain.site.records :
    "${record.record}-${record.type}-${record.name}" => record
  } : {}

  zone_id  = var.cloudflare_zone_id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.value
  priority = try(tonumber(each.value.priority), null)
  ttl      = 1
  proxied  = false
  comment  = "Managed by OpenTofu for Resend domain verification"
}

resource "resend_domain_verification" "site" {
  count = var.enable_resend_domain_verification ? 1 : 0

  domain_id = resend_domain.site.id

  depends_on = [cloudflare_dns_record.resend]
}
