resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
  production_branch = "main"
}

resource "cloudflare_pages_domain" "site" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = local.domain

  depends_on = [cloudflare_dns_record.site]
}
