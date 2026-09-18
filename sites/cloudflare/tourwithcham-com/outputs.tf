output "pages_project_subdomain" {
  description = "Cloudflare Pages project subdomain."
  value       = cloudflare_pages_project.site.subdomain
}

output "site_url" {
  description = "Public website URL."
  value       = "https://${local.domain}"
}

output "turnstile_sitekey" {
  description = "Public site key for the inquiry Turnstile widget."
  value       = cloudflare_turnstile_widget.inquiry.sitekey
}
