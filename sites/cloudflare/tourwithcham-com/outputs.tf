output "pages_project_subdomain" {
  description = "Cloudflare Pages project subdomain."
  value       = cloudflare_pages_project.site.subdomain
}

output "site_url" {
  description = "Public website URL."
  value       = "https://${local.domain}"
}

output "inquiries_database_id" {
  description = "ID of the D1 database that stores tour inquiries."
  value       = cloudflare_d1_database.inquiries.id
}

output "inquiries_database_name" {
  description = "Name of the D1 database that stores tour inquiries."
  value       = cloudflare_d1_database.inquiries.name
}

output "review_photos_bucket_name" {
  description = "Name of the private R2 bucket that stores customer review photos."
  value       = cloudflare_r2_bucket.review_photos.name
}

output "turnstile_sitekey" {
  description = "Public site key for the inquiry Turnstile widget."
  value       = cloudflare_turnstile_widget.inquiry.sitekey
}
