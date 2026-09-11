resource "cloudflare_dns_record" "site" {
  zone_id = var.cloudflare_zone_id
  name    = "eap"
  comment = "[OpenTofu/iac] Cloudflare Pages custom domain for eap.oczadly.io"
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
  ttl     = 1
}
