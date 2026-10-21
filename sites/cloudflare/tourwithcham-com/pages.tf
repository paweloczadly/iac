resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
  production_branch = "main"

  deployment_configs = {
    preview = {
      compatibility_date = local.compatibility_date
      fail_open          = true
      d1_databases = {
        INQUIRIES_DB = {
          id = cloudflare_d1_database.inquiries.id
        }
      }
      r2_buckets = {
        REVIEW_PHOTOS = {
          name         = cloudflare_r2_bucket.review_photos.name
          jurisdiction = cloudflare_r2_bucket.review_photos.jurisdiction
        }
      }
      env_vars = {
        TURNSTILE_SITE_KEY = {
          type  = "plain_text"
          value = cloudflare_turnstile_widget.inquiry.sitekey
        }
        TURNSTILE_SECRET_KEY = {
          type  = "secret_text"
          value = cloudflare_turnstile_widget.inquiry.secret
        }
        RESEND_API_KEY = {
          type  = "secret_text"
          value = resend_api_key.pages.token
        }
        INQUIRY_EMAIL_FROM = {
          type  = "plain_text"
          value = "Tour with Cham <${local.inquiry_email_address}>"
        }
        INQUIRY_REPLY_TO = {
          type  = "plain_text"
          value = local.inquiry_email_address
        }
        INQUIRY_NOTIFICATION_TO = {
          type  = "plain_text"
          value = join(",", sort(tolist(var.notification_recipients)))
        }
      }
    }
    production = {
      compatibility_date = local.compatibility_date
      fail_open          = true
      d1_databases = {
        INQUIRIES_DB = {
          id = cloudflare_d1_database.inquiries.id
        }
      }
      r2_buckets = {
        REVIEW_PHOTOS = {
          name         = cloudflare_r2_bucket.review_photos.name
          jurisdiction = cloudflare_r2_bucket.review_photos.jurisdiction
        }
      }
      env_vars = {
        TURNSTILE_SITE_KEY = {
          type  = "plain_text"
          value = cloudflare_turnstile_widget.inquiry.sitekey
        }
        TURNSTILE_SECRET_KEY = {
          type  = "secret_text"
          value = cloudflare_turnstile_widget.inquiry.secret
        }
        RESEND_API_KEY = {
          type  = "secret_text"
          value = resend_api_key.pages.token
        }
        INQUIRY_EMAIL_FROM = {
          type  = "plain_text"
          value = "Tour with Cham <${local.inquiry_email_address}>"
        }
        INQUIRY_REPLY_TO = {
          type  = "plain_text"
          value = local.inquiry_email_address
        }
        INQUIRY_NOTIFICATION_TO = {
          type  = "plain_text"
          value = join(",", sort(tolist(var.notification_recipients)))
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
