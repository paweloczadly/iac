resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
  production_branch = "main"

  deployment_configs = {
    preview = {
      compatibility_date = local.compatibility_date
      fail_open          = true
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
          # See the preview configuration above for why this is plain_text.
          type  = "plain_text"
          value = terraform_data.resend_pages_api_key_token.output
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
        DEPLOYMENT_ENVIRONMENT = {
          type  = "plain_text"
          value = "production"
        }
      }
    }
  }

  # The legacy preview bindings are unused now that staging has its own Pages
  # project. Cloudflare's merge API cannot clear them, and provider 5.x cannot
  # safely serialize multiple binding maps (upstream issue #7306).
  lifecycle {
    ignore_changes = [deployment_configs.preview]
  }

}

resource "cloudflare_pages_project" "staging" {
  account_id        = var.cloudflare_account_id
  name              = local.staging_project_name
  production_branch = local.staging_branch

  deployment_configs = {
    preview = {
      compatibility_date = local.compatibility_date
      fail_open          = true
    }
    production = {
      compatibility_date = local.compatibility_date
      fail_open          = true
      d1_databases = {
        INQUIRIES_DB = {
          id = cloudflare_d1_database.staging_inquiries.id
        }
      }
      r2_buckets = {
        REVIEW_PHOTOS = {
          name = cloudflare_r2_bucket.staging_review_photos.name
        }
      }
      env_vars = {
        TURNSTILE_SITE_KEY = {
          type  = "plain_text"
          value = cloudflare_turnstile_widget.staging_inquiry.sitekey
        }
        TURNSTILE_SECRET_KEY = {
          type  = "secret_text"
          value = cloudflare_turnstile_widget.staging_inquiry.secret
        }
        RESEND_API_KEY = {
          type  = "plain_text"
          value = terraform_data.resend_pages_api_key_token.output
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
        DEPLOYMENT_ENVIRONMENT = {
          type  = "plain_text"
          value = "staging"
        }
        EMAIL_RECIPIENT_OVERRIDE = {
          type  = "plain_text"
          value = var.staging_email_recipient
        }
        EMAIL_SUBJECT_PREFIX = {
          type  = "plain_text"
          value = "[STAGING]"
        }
      }
    }
  }

  # Pages redacts secret_text values on read, so the provider cannot compare
  # the persisted Turnstile secret with its configured value after creation.
  lifecycle {
    ignore_changes = [deployment_configs.production.env_vars["TURNSTILE_SECRET_KEY"].value]
  }
}

resource "cloudflare_pages_domain" "site" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = local.domain

  depends_on = [cloudflare_dns_record.site]
}

resource "cloudflare_pages_domain" "staging" {
  count = var.enable_staging_custom_domain ? 1 : 0

  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.staging.name
  name         = local.staging_domain

  depends_on = [cloudflare_dns_record.staging]
}
