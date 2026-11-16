resource "cloudflare_r2_bucket" "review_photos" {
  account_id   = var.cloudflare_account_id
  name         = local.review_photos_bucket
  jurisdiction = "eu"
}

resource "cloudflare_r2_bucket" "staging_review_photos" {
  account_id = var.cloudflare_account_id
  name       = local.staging_photos_bucket
}
