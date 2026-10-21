variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns the Pages project."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for tourwithcham.com."
  type        = string
}

variable "resend_api_key" {
  description = "Resend management API key used only by OpenTofu to manage the domain and create a domain-scoped sending key."
  type        = string
  sensitive   = true
}

variable "inquiry_notification_destination" {
  description = "Verified mailbox that receives inquiry notifications and forwarded customer replies."
  type        = string
  default     = "paweloczadly@gmail.com"
}

variable "notification_recipients" {
  description = "Mailboxes that receive inquiry and review notifications from Resend."
  type        = set(string)
  default = [
    "paweloczadly@gmail.com",
    "cnilanka87@gmail.com",
  ]

  validation {
    condition     = length(var.notification_recipients) > 0 && alltrue([for email in var.notification_recipients : can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", email))])
    error_message = "Every notification recipient must be a valid email address."
  }
}

variable "enable_inquiry_email_routing_rule" {
  description = "Create the bookings@ forwarding rule after the destination address has been verified."
  type        = bool
  default     = false
}

variable "enable_resend_domain_verification" {
  description = "Create Resend DNS records and trigger verification after the domain has been created by an earlier apply."
  type        = bool
  default     = false
}
