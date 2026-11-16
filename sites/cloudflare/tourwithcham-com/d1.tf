resource "cloudflare_d1_database" "inquiries" {
  account_id   = var.cloudflare_account_id
  name         = local.inquiries_database
  jurisdiction = "eu"

  read_replication = {
    mode = "disabled"
  }
}

resource "cloudflare_d1_database" "staging_inquiries" {
  account_id   = var.cloudflare_account_id
  name         = local.staging_database
  jurisdiction = "eu"

  read_replication = {
    mode = "disabled"
  }
}
