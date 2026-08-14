variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns the Pages project."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for oczadly.io."
  type        = string
}

variable "member_emails" {
  description = "Email addresses allowed to access eap.oczadly.io."
  type        = set(string)
  sensitive   = true

  validation {
    condition     = length(var.member_emails) > 0
    error_message = "At least one member email address must be provided."
  }
}
