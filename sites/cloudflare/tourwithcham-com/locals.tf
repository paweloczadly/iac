locals {
  domain                = "tourwithcham.com"
  project_name          = "tourwithcham-com"
  pages_domain          = "${local.project_name}.pages.dev"
  compatibility_date    = "2026-09-15"
  inquiries_database    = "tourwithcham-inquiries"
  review_photos_bucket  = "tourwithcham-review-photos"
  turnstile_widget_name = "tourwithcham-inquiry"
}
