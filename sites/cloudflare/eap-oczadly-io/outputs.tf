output "pages_project_subdomain" {
  description = "Cloudflare Pages project subdomain."
  value       = cloudflare_pages_project.site.subdomain
}

output "site_url" {
  description = "Member-facing URL protected by Cloudflare Access."
  value       = "https://${local.domain}"
}

output "access_application_id" {
  description = "Cloudflare Access application ID."
  value       = cloudflare_zero_trust_access_application.site.id
}
