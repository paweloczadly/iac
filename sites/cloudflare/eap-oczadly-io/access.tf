resource "cloudflare_zero_trust_access_identity_provider" "one_time_pin" {
  account_id = var.cloudflare_account_id
  name       = "One-time PIN"
  type       = "onetimepin"
  config     = {}
}

resource "cloudflare_zero_trust_access_application" "site" {
  account_id                = var.cloudflare_account_id
  name                      = local.project_name
  type                      = "self_hosted"
  session_duration          = "24h"
  app_launcher_visible      = false
  auto_redirect_to_identity = true
  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.one_time_pin.id]

  destinations = [
    {
      type = "public"
      uri  = local.domain
    },
    {
      type = "public"
      uri  = cloudflare_pages_project.site.subdomain
    },
    {
      type = "public"
      uri  = "*.${cloudflare_pages_project.site.subdomain}"
    },
  ]

  policies = [
    {
      name       = "Allow members"
      decision   = "allow"
      precedence = 1
      include = [
        for email in var.member_emails : {
          email = {
            email = email
          }
        }
      ]
    }
  ]

  depends_on = [cloudflare_pages_domain.site]
}
