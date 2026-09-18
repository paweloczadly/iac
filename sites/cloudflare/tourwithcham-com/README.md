# tourwithcham.com

OpenTofu configuration for the `tourwithcham.com` Cloudflare Pages Direct Upload project, custom domain, DNS record, and Turnstile widget.

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
- `Account > Turnstile Sites > Edit`

Every push to `main` triggers a production deployment.

## Turnstile

OpenTofu creates a managed Turnstile widget for `tourwithcham.com` and the project's `pages.dev` domain. The public site key and sensitive secret key are configured as Pages environment variables for production and preview deployments:

- `TURNSTILE_SITE_KEY`
- `TURNSTILE_SECRET_KEY`

The secret is stored in OpenTofu state. Keep the state file outside version control and restrict access to it.
