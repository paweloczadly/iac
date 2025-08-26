locals {
  name_oczadly_io = "oczadly.io"

  gh_pages_ip_addresses = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

resource "cloudflare_dns_record" "a_oczadly_io" {
  for_each = toset(local.gh_pages_ip_addresses)

  zone_id = var.cloudflare_zone_id
  name    = local.name_oczadly_io
  comment = "[OpenTofu/iac] GitHub Pages IP address for oczadly.io"
  type    = "A"
  content = each.key
  ttl     = 3600
}

resource "cloudflare_dns_record" "cname_www_oczadly_io" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  comment = "[OpenTofu/iac] GitHub CNAME record to paweloczadly.github.io"
  type    = "CNAME"
  content = "paweloczadly.github.io"
  ttl     = 60
}

resource "cloudflare_dns_record" "txt_gradle_verification" {
  zone_id = var.cloudflare_zone_id
  name    = local.name_oczadly_io
  comment = "[OpenTofu/iac] Gradle Plugins verification"
  type    = "TXT"
  content = "\"gradle-verification=2DDLSGLSIMTFMOKOLOML252NTGKPG\""
  ttl     = 60
}
