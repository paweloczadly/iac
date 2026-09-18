resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
  production_branch = "main"

  deployment_configs = {
    preview = {
      compatibility_date = local.compatibility_date
      fail_open          = true
      env_vars = {
        TURNSTILE_SITE_KEY = {
          type  = "plain_text"
          value = cloudflare_turnstile_widget.inquiry.sitekey
        }
        TURNSTILE_SECRET_KEY = {
          type  = "secret_text"
          value = cloudflare_turnstile_widget.inquiry.secret
        }
      }
    }
    production = {
      compatibility_date = local.compatibility_date
      fail_open          = true
      env_vars = {
        TURNSTILE_SITE_KEY = {
          type  = "plain_text"
          value = cloudflare_turnstile_widget.inquiry.sitekey
        }
        TURNSTILE_SECRET_KEY = {
          type  = "secret_text"
          value = cloudflare_turnstile_widget.inquiry.secret
        }
      }
    }
  }
}

resource "cloudflare_pages_domain" "site" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = local.domain

  depends_on = [cloudflare_dns_record.site]
}
