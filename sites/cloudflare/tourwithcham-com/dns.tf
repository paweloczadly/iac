resource "cloudflare_dns_record" "site" {
  zone_id = var.cloudflare_zone_id
  name    = local.domain
  comment = "[OpenTofu/iac] Cloudflare Pages custom domain for tourwithcham.com"
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "staging" {
  count = var.enable_staging_custom_domain ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = local.staging_domain
  comment = "[OpenTofu/iac] Cloudflare Pages staging environment"
  type    = "CNAME"
  content = cloudflare_pages_project.staging.subdomain
  proxied = true
  ttl     = 1
}
