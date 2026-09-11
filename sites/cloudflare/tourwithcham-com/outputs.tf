output "pages_project_subdomain" {
  description = "Cloudflare Pages project subdomain."
  value       = cloudflare_pages_project.site.subdomain
}

output "site_url" {
  description = "Public website URL."
  value       = "https://${local.domain}"
}
