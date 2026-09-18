resource "cloudflare_d1_database" "inquiries" {
  account_id   = var.cloudflare_account_id
  name         = local.inquiries_database
  jurisdiction = "eu"
}
