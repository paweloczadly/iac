resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
  production_branch = "main"

  build_config = {
    build_command   = "hugo --minify"
    destination_dir = "public"
    root_dir        = ""
  }

  deployment_configs = {
    preview = {
      fail_open = false
    }
    production = {
      fail_open = false
      env_vars = {
        HUGO_VERSION = {
          type  = "plain_text"
          value = "0.147.0"
        }
      }
    }
  }

  source = {
    type = "github"
    config = {
      owner                          = local.repository.owner
      repo_name                      = local.repository.name
      production_branch              = "main"
      production_deployments_enabled = true
      preview_deployment_setting     = "none"
      pr_comments_enabled            = false
    }
  }
}

resource "cloudflare_pages_domain" "site" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = local.domain

  depends_on = [cloudflare_dns_record.site]
}
