# tourwithcham.com

OpenTofu configuration for the `tourwithcham.com` Cloudflare Pages Direct Upload project, custom domain, DNS record, Turnstile widget, inquiry database, and private review-photo storage.

## Prerequisites

- The `tourwithcham.com` zone exists in the Cloudflare account.
- `CLOUDFLARE_API_TOKEN` is set.
- `cloudflare_account_id` and `cloudflare_zone_id` are provided locally.

## Apply

```bash
tofu init
tofu plan -var-file=terraform.local.tfvars
tofu apply -var-file=terraform.local.tfvars
```

The website repository deploys the static assets with GitHub Actions and Wrangler. Configure these GitHub Actions repository secrets:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`

The API token requires the following permissions for the account that owns this project:

- `Account > Cloudflare Pages > Edit`
- `Account > D1 > Edit`
- `Account > Workers R2 Storage > Edit`
- `Account > Turnstile Sites > Edit`
- `Zone > Zone Settings > Edit`

Every push to `main` triggers a production deployment.

OpenTofu sets the zone Browser Cache TTL to `Respect Existing Headers`. This allows Pages `_headers` rules to require revalidation for mutable JavaScript and CSS while retaining the platform cache behavior for images.

## Turnstile

OpenTofu creates a managed Turnstile widget for `tourwithcham.com` and the project's `pages.dev` domain. The public site key and sensitive secret key are configured as Pages environment variables for production and preview deployments:

- `TURNSTILE_SITE_KEY`
- `TURNSTILE_SECRET_KEY`

The secret is stored in OpenTofu state. Keep the state file outside version control and restrict access to it.

## Inquiry database

OpenTofu creates the EU-jurisdiction D1 database `tourwithcham-inquiries` and exposes it to production and preview Pages Functions through the `INQUIRIES_DB` binding. Database schema migrations are versioned and applied by the website repository's deployment workflow.

The GitHub Actions Cloudflare API token requires `Account > D1 > Edit` so the deployment workflow can apply pending migrations before uploading the application.

## Review photo storage

OpenTofu creates the EU-jurisdiction R2 bucket `tourwithcham-review-photos` and exposes it to production and preview Pages Functions through the `REVIEW_PHOTOS` binding.

The bucket has no public custom domain or `r2.dev` configuration. Review photos remain private objects and are returned only by the website function after it confirms that the corresponding review is approved in D1.

The API token used by OpenTofu requires `Account > Workers R2 Storage > Edit`. Application deployments do not upload objects and therefore do not require R2 write permission in the GitHub Actions deployment token.
