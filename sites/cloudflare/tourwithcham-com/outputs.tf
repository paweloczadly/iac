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

output "inquiry_email_address" {
  description = "Public reply address used for tour inquiries."
  value       = local.inquiry_email_address
}

output "inquiry_email_destination_status" {
  description = "Cloudflare verification status of the mailbox receiving forwarded inquiry replies."
  value       = cloudflare_email_routing_address.inquiries.verified != null ? "verified" : "pending"
}

output "inquiry_email_destination_verified_at" {
  description = "Timestamp when Cloudflare verified the mailbox receiving forwarded inquiry replies."
  value       = cloudflare_email_routing_address.inquiries.verified
}

output "resend_domain_status" {
  description = "Resend sending-domain status reported by the domain resource."
  value       = resend_domain.site.status
}

output "resend_domain_verification_status" {
  description = "Resend verification result; null until enable_resend_domain_verification is enabled."
  value       = try(resend_domain_verification.site[0].status, null)
}

output "resend_pages_api_key_id" {
  description = "ID of the domain-scoped sending-only Resend key used by Pages Functions."
  value       = resend_api_key.pages.id
}
